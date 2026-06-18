import 'package:flutter/material.dart';

import 'shimmer_widgets.dart';

/// Skeleton for [GamesList] while games load.
class GamesListShimmer extends StatelessWidget {
  final int itemCount;

  const GamesListShimmer({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    final imageHeight = MediaQuery.sizeOf(context).width / 2;

    return AppShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (_, _) => ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(
                height: imageHeight,
                width: double.infinity,
                borderRadius: BorderRadius.circular(8),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      height: 18,
                      width: double.infinity,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    SizedBox(height: 6),
                    ShimmerBox(
                      height: 18,
                      width: 180,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
