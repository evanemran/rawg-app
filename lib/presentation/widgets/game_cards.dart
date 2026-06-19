import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../domain/models/games.dart';
import 'app_widgets.dart';

/// Large hero card used in the "Featured" carousel.
class FeaturedGameCard extends StatelessWidget {
  final Games game;
  final VoidCallback onTap;

  const FeaturedGameCard({super.key, required this.game, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            GameImage(url: game.backgroundImage),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.45, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    game.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (gameYear(game.released) != null) ...[
                        Text(
                          gameYear(game.released)!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      RatingBadge(rating: game.rating, fontSize: 13),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vertical poster card used in horizontal lists like "Popular Now".
class PosterGameCard extends StatelessWidget {
  final Games game;
  final VoidCallback onTap;
  final double width;

  const PosterGameCard({
    super.key,
    required this.game,
    required this.onTap,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: GameImage(
                  url: game.backgroundImage,
                  width: width,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              game.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  gameYear(game.released) ?? '',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                RatingBadge(rating: game.rating, fontSize: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Genre filter chip with an icon.
class GenreChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const GenreChip({
    super.key,
    required this.label,
    this.icon = Icons.sports_esports_rounded,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.accent, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal list row used for search results.
class GameSearchTile extends StatelessWidget {
  final Games game;
  final VoidCallback onTap;

  const GameSearchTile({super.key, required this.game, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final platform = (game.parentPlatforms != null &&
            game.parentPlatforms!.isNotEmpty)
        ? game.parentPlatforms!.first.platform?.name
        : null;
    final year = gameYear(game.released);
    final subtitle = [year, platform].whereType<String>().join('  ·  ');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GameImage(
                url: game.backgroundImage,
                width: 56,
                height: 56,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            RatingBadge(rating: game.rating, fontSize: 13),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
