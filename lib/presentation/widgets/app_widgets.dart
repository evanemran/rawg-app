import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'shimmer_widgets.dart';

/// Extracts the release year (e.g. "2018") from a RAWG date string.
String? gameYear(String? released) {
  if (released == null || released.isEmpty) return null;
  return released.split('-').first;
}

/// Maps a RAWG parent-platform slug to a representative Material icon.
IconData platformIcon(String? slug) {
  switch (slug) {
    case 'pc':
      return Icons.computer_rounded;
    case 'playstation':
      return Icons.sports_esports_rounded;
    case 'xbox':
      return Icons.videogame_asset_rounded;
    case 'nintendo':
      return Icons.gamepad_rounded;
    case 'mac':
      return Icons.laptop_mac_rounded;
    case 'linux':
      return Icons.terminal_rounded;
    case 'ios':
    case 'android':
      return Icons.smartphone_rounded;
    case 'web':
      return Icons.public_rounded;
    default:
      return Icons.devices_rounded;
  }
}

/// A section title row with an optional "View all" action.
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const SectionHeader({super.key, required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: const Text(
                'View all',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Small star + numeric rating badge used on cards and tiles.
class RatingBadge extends StatelessWidget {
  final double? rating;
  final double fontSize;

  const RatingBadge({super.key, required this.rating, this.fontSize = 13});

  @override
  Widget build(BuildContext context) {
    if (rating == null || rating == 0) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: AppColors.star, size: fontSize + 4),
        const SizedBox(width: 3),
        Text(
          rating!.toStringAsFixed(1),
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// Network image with a consistent dark placeholder and error fallback.
class GameImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const GameImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _placeholder();
    }
    return Image.network(
      url!,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return ShimmerImagePlaceholder(
          width: width,
          height: height,
        );
      },
      errorBuilder: (context, _, _) => _placeholder(
        child: const Icon(Icons.image_not_supported_outlined,
            color: AppColors.textTertiary),
      ),
    );
  }

  Widget _placeholder({Widget? child}) {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceVariant,
      alignment: Alignment.center,
      child: child,
    );
  }
}
