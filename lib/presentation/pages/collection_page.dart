import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../domain/models/collection_game.dart';
import '../providers/collection_provider.dart';
import '../widgets/collection_widgets.dart';
import '../widgets/shimmer_widgets.dart';
import 'game_details_navigation.dart';

class CollectionPage extends ConsumerWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionAsync = ref.watch(userCollectionProvider);
    final selectedTab = ref.watch(collectionTabProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: collectionAsync.when(
          loading: () => const _CollectionLoading(),
          error: (_, _) => const _CollectionError(),
          data: (games) {
            final stats = computeCollectionStats(games);
            final filtered = filterCollectionByTab(games, selectedTab);

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: CollectionHeader(
                    onSearchTap: () => _showComingSoon(context, 'Search'),
                    onFilterTap: () => _showComingSoon(context, 'Filter'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CollectionTabBar(
                    selected: selectedTab,
                    onSelected: (tab) =>
                        ref.read(collectionTabProvider.notifier).state = tab,
                  ),
                ),
                SliverToBoxAdapter(
                  child: CollectionStatsRow(
                    totalGames: stats.totalGames,
                    completedCount: stats.completedCount,
                    playedPercent: stats.playedPercent,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Text(
                      'Recently Added',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (filtered.isEmpty)
                  SliverToBoxAdapter(
                    child: CollectionEmptyState(
                      message: _emptyMessage(selectedTab),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _CollectionListItem(
                        game: filtered[index],
                      ),
                      childCount: filtered.length,
                    ),
                  ),
                if (filtered.isNotEmpty)
                  SliverToBoxAdapter(
                    child: CollectionViewAllLink(
                      onTap: () => _showComingSoon(
                        context,
                        'Full collection view',
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _emptyMessage(CollectionTab tab) {
    switch (tab) {
      case CollectionTab.games:
        return 'Games you save will appear here.\nOpen a game and tap Collection to add it.';
      case CollectionTab.dlc:
        return 'DLC tracking is coming soon.';
      case CollectionTab.wishlist:
        return 'No wishlist games yet.';
      case CollectionTab.played:
        return 'No played games yet.';
    }
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _CollectionListItem extends StatelessWidget {
  final CollectionGame game;

  const _CollectionListItem({required this.game});

  @override
  Widget build(BuildContext context) {
    return CollectionGameTile(
      name: game.name,
      released: game.released,
      genre: game.genre,
      rating: game.rating,
      imageUrl: game.backgroundImage,
      onTap: () => openGameDetails(context, game.toGames()),
    );
  }
}

class _CollectionLoading extends StatelessWidget {
  const _CollectionLoading();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: CollectionHeader()),
          SliverToBoxAdapter(child: SizedBox(height: 48)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ShimmerBox(
                      height: 88,
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ShimmerBox(
                      height: 88,
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ShimmerBox(
                      height: 88,
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionError extends StatelessWidget {
  const _CollectionError();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Could not load your collection.',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
