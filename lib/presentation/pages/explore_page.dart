import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../domain/models/games.dart';
import '../providers/games_provider.dart';
import '../widgets/game_cards.dart';
import '../widgets/explore_shimmer.dart';
import 'game_details_navigation.dart';

const _tabs = ['All', 'Games', 'DLC', 'Articles', 'Users'];

/// RAWG returns 20 results per page by default; used to infer whether another
/// page is available without an extra "count" round-trip.
const _pageSize = 20;

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  String _query = '';
  int _selectedTab = 0;

  final List<Games> _items = [];
  int _page = 1;
  bool _initialLoading = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  Object? _error;

  /// Guards against out-of-order responses when the query changes mid-request.
  int _requestId = 0;

  bool get _gamesTab => _selectedTab == 0 || _selectedTab == 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitial();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<Games>> _fetchPage(int page) {
    if (_query.isEmpty) {
      return ref.read(getGamesProvider)(page);
    }
    return ref.read(searchGamesProvider)(_query, page);
  }

  Future<void> _loadInitial() async {
    if (!_gamesTab) return;
    final reqId = ++_requestId;
    setState(() {
      _initialLoading = true;
      _loadingMore = false;
      _error = null;
      _items.clear();
      _page = 1;
      _hasMore = true;
    });
    try {
      final batch = await _fetchPage(1);
      if (reqId != _requestId || !mounted) return;
      setState(() {
        _items.addAll(batch);
        _hasMore = batch.length >= _pageSize;
        _initialLoading = false;
      });
    } catch (e) {
      if (reqId != _requestId || !mounted) return;
      setState(() {
        _error = e;
        _initialLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _initialLoading || !_hasMore || !_gamesTab) return;
    final reqId = _requestId;
    final nextPage = _page + 1;
    setState(() => _loadingMore = true);
    try {
      final batch = await _fetchPage(nextPage);
      if (reqId != _requestId || !mounted) return;
      setState(() {
        _page = nextPage;
        _items.addAll(batch);
        _hasMore = batch.length >= _pageSize;
        _loadingMore = false;
      });
    } catch (_) {
      if (reqId != _requestId || !mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      _loadMore();
    }
  }

  void _onChanged(String value) {
    setState(() {}); // refresh the clear button
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final q = value.trim();
      if (q == _query) return;
      _query = q;
      _loadInitial();
    });
  }

  void _clear() {
    _controller.clear();
    if (_query.isNotEmpty) {
      _query = '';
      _loadInitial();
    } else {
      setState(() {});
    }
  }

  void _cancel() {
    _clear();
    _focusNode.unfocus();
  }

  void _onTabSelected(int index) {
    if (index == _selectedTab) return;
    final wasGamesTab = _gamesTab;
    setState(() => _selectedTab = index);
    // Load games when entering a games tab for the first time.
    if (!wasGamesTab && _gamesTab && _items.isEmpty && !_initialLoading) {
      _loadInitial();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildSearchBar(),
            _buildTabs(),
            const SizedBox(height: 8),
            Expanded(child: _buildResults()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded,
                      color: AppColors.textSecondary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onChanged: _onChanged,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (v) {
                        _query = v.trim();
                        _loadInitial();
                      },
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                      ),
                      cursorColor: AppColors.accent,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Search games...',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  if (_controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: _clear,
                      child: const Icon(Icons.cancel_rounded,
                          color: AppColors.textSecondary, size: 18),
                    ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: _cancel,
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final active = index == _selectedTab;
          return GestureDetector(
            onTap: () => _onTabSelected(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _tabs[index],
                  style: TextStyle(
                    color:
                        active ? AppColors.textPrimary : AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 2,
                  width: 22,
                  decoration: BoxDecoration(
                    color: active ? AppColors.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResults() {
    if (!_gamesTab) {
      return _EmptyState(
        icon: Icons.upcoming_rounded,
        message: 'No ${_tabs[_selectedTab]} results yet.',
      );
    }

    if (_initialLoading) {
      return const ExploreShimmer();
    }

    if (_error != null && _items.isEmpty) {
      return _EmptyState(
        icon: Icons.error_outline_rounded,
        message: 'Something went wrong.',
        onRetry: _loadInitial,
      );
    }

    if (_items.isEmpty) {
      return _EmptyState(
        icon: _query.isEmpty
            ? Icons.videogame_asset_outlined
            : Icons.search_off_rounded,
        message: _query.isEmpty
            ? 'Start typing to search games.'
            : 'No games found for "$_query".',
      );
    }

    final header = _query.isEmpty ? 'Popular' : 'Games';
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: _items.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              '$header (${_items.length})',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }
        if (index <= _items.length) {
          final game = _items[index - 1];
          return GameSearchTile(
            game: game,
            onTap: () => openGameDetails(context, game),
          );
        }
        return _buildFooter();
      },
    );
  }

  Widget _buildFooter() {
    if (_loadingMore) {
      return const ExploreLoadMoreShimmer();
    }
    if (!_hasMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'No more results',
            style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
          ),
        ),
      );
    }
    return const SizedBox(height: 24);
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  const _EmptyState({
    required this.icon,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textTertiary, size: 40),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}
