import 'package:flutter/material.dart';

import 'shimmer_widgets.dart';

/// Skeleton for the "About" section while game details load.
class DescriptionShimmer extends StatelessWidget {
  const DescriptionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerSectionHeader(showViewAll: false),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DescriptionLine(widthFactor: 1),
                SizedBox(height: 8),
                _DescriptionLine(widthFactor: 1),
                SizedBox(height: 8),
                _DescriptionLine(widthFactor: 0.85),
                SizedBox(height: 8),
                _DescriptionLine(widthFactor: 0.6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionLine extends StatelessWidget {
  final double widthFactor;

  const _DescriptionLine({required this.widthFactor});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: const ShimmerBox(
        height: 14,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
  }
}
