import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../domain/models/genres.dart';
import '../providers/genre_providers.dart';
import '../widgets/catalog_list_tile.dart';
import '../widgets/drawer_menu_button.dart';
import '../widgets/explore_shimmer.dart';
import 'game_list_navigation.dart';

const _pageSize = 20;

class GenresMenuPage extends ConsumerStatefulWidget {
  const GenresMenuPage({super.key});

  @override
  ConsumerState<GenresMenuPage> createState() => _GenresMenuPageState();
}

class _GenresMenuPageState extends ConsumerState<GenresMenuPage> {
  final ScrollController _scrollController = ScrollController();
  final List<Genre> _items = [];
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
      final batch = await ref.read(getGenresProvider)(1);
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
      final batch = await ref.read(getGenresProvider)(nextPage);
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
        leading: const DrawerMenuButton(),
        title: const Text('Genres'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_initialLoading) return const ExploreShimmer();

    if (_error != null && _items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Failed to load genres.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: _loadInitial, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
      return const Center(
        child: Text(
          'No genres found.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInitial,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: _items.length + (_loadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _items.length) {
            return const ExploreLoadMoreShimmer();
          }
          final genre = _items[index];
          final name = genre.name ?? 'Genre';
          final slug = genre.slug;
          return CatalogListTile(
            title: name,
            subtitle: genre.gamesCount != null
                ? '${genre.gamesCount} games'
                : null,
            imageUrl: genre.imageBackground,
            onTap: () {
              if (slug == null || slug.isEmpty) return;
              openGameList(context, title: name, genre: slug);
            },
          );
        },
      ),
    );
  }
}
