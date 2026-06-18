import 'package:flutter/material.dart';

import 'shimmer_widgets.dart';

/// Skeleton for the explore page game list while the first page loads.
class ExploreShimmer extends StatelessWidget {
  final int itemCount;

  const ExploreShimmer({super.key, this.itemCount = 8});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: ShimmerBox(
              width: 100,
              height: 17,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          ...List.generate(itemCount, (_) => const ShimmerGameSearchTile()),
        ],
      ),
    );
  }
}

/// Skeleton tiles shown at the bottom of the explore list while loading more.
class ExploreLoadMoreShimmer extends StatelessWidget {
  const ExploreLoadMoreShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Column(
        children: [
          ShimmerGameSearchTile(),
          ShimmerGameSearchTile(),
        ],
      ),
    );
  }
}
