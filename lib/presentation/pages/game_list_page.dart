import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../domain/models/games.dart';
import '../providers/games_provider.dart';
import '../widgets/explore_shimmer.dart';
import '../widgets/game_cards.dart';
import 'game_details_navigation.dart';

/// RAWG returns 20 results per page by default.
const _pageSize = 20;

class GameListPage extends ConsumerStatefulWidget {
  final String title;

  const GameListPage({super.key, required this.title});

  @override
  ConsumerState<GameListPage> createState() => _GameListPageState();
}

class _GameListPageState extends ConsumerState<GameListPage> {
  final ScrollController _scrollController = ScrollController();

  final List<Games> _items = [];
  int _page = 1;
  bool _initialLoading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitial();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    setState(() {
      _initialLoading = true;
      _loadingMore = false;
      _error = null;
      _items.clear();
      _page = 1;
      _hasMore = true;
    });

    try {
      final batch = await ref.read(getGamesProvider)(1);
      if (!mounted) return;
      setState(() {
        _items.addAll(batch);
        _hasMore = batch.length >= _pageSize;
        _initialLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _initialLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _initialLoading || !_hasMore) return;

    final nextPage = _page + 1;
    setState(() => _loadingMore = true);

    try {
      final batch = await ref.read(getGamesProvider)(nextPage);
      if (!mounted) return;
      setState(() {
        _page = nextPage;
        _items.addAll(batch);
        _hasMore = batch.length >= _pageSize;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_initialLoading) {
      return const ExploreShimmer();
    }

    if (_error != null && _items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Failed to load games.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loadInitial,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
      return const Center(
        child: Text(
          'No games found.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInitial,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: _items.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                '${_items.length} games',
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
      ),
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
            'No more games',
            style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
          ),
        ),
      );
    }
    return const SizedBox(height: 24);
  }
}
