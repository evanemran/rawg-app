import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/theme/app_colors.dart';

/// Wraps [child] with a Facebook-style shimmer animation tuned for the dark theme.
class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceVariant,
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}

/// A solid block placeholder used inside [AppShimmer].
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: borderRadius,
      ),
    );
  }
}

/// Skeleton for a [SectionHeader] row.
class ShimmerSectionHeader extends StatelessWidget {
  final bool showViewAll;

  const ShimmerSectionHeader({super.key, this.showViewAll = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const ShimmerBox(
            width: 110,
            height: 18,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          if (showViewAll)
            const ShimmerBox(
              width: 56,
              height: 13,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
        ],
      ),
    );
  }
}

/// Skeleton for a [GameSearchTile].
class ShimmerGameSearchTile extends StatelessWidget {
  const ShimmerGameSearchTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          ShimmerBox(
            width: 56,
            height: 56,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  height: 15,
                  width: double.infinity,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                SizedBox(height: 6),
                ShimmerBox(
                  height: 12,
                  width: 120,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          ShimmerBox(
            width: 36,
            height: 14,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ],
      ),
    );
  }
}

/// Pulsing placeholder sized for [GameImage] while a network image loads.
class ShimmerImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const ShimmerImagePlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ShimmerBox(
        width: width,
        height: height,
        borderRadius: borderRadius,
      ),
    );
  }
}
