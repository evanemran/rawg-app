import 'package:flutter/material.dart';

import 'shimmer_widgets.dart';

/// Skeleton layout that mirrors the home page content while games load.
class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerSectionHeader(),
          _FeaturedCarouselShimmer(),
          SizedBox(height: 20),
          ShimmerSectionHeader(),
          _PopularRowShimmer(),
          SizedBox(height: 20),
          ShimmerSectionHeader(),
          SizedBox(height: 44, child: _GenreRowShimmer()),
        ],
      ),
    );
  }
}

/// Skeleton for the horizontal genre chip row.
class GenreRowShimmer extends StatelessWidget {
  const GenreRowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: SizedBox(
        height: 44,
        child: _GenreRowShimmer(),
      ),
    );
  }
}

class _FeaturedCarouselShimmer extends StatelessWidget {
  const _FeaturedCarouselShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, right: 24),
          child: ShimmerBox(
            height: 190,
            width: double.infinity,
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (_) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 3),
              child: ShimmerBox(
                width: 6,
                height: 6,
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PopularRowShimmer extends StatelessWidget {
  const _PopularRowShimmer();

  static const _cardWidth = 130.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, _) => const SizedBox(
          width: _cardWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ShimmerBox(
                  width: _cardWidth,
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
              ),
              SizedBox(height: 8),
              ShimmerBox(
                height: 14,
                width: _cardWidth,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              SizedBox(height: 6),
              ShimmerBox(
                height: 12,
                width: 72,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenreRowShimmer extends StatelessWidget {
  const _GenreRowShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(width: 10),
      itemBuilder: (_, _) => const ShimmerBox(
        width: 96,
        height: 38,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
