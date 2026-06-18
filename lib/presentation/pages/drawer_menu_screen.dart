import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../app/theme/app_colors.dart';
import '../providers/drawer_provider.dart';

class DrawerMenuScreen extends ConsumerWidget {
  const DrawerMenuScreen({super.key});

  IconData _iconFor(DrawerMenu menu) {
    switch (menu) {
      case DrawerMenu.games:
        return Icons.sports_esports_rounded;
      case DrawerMenu.genres:
        return Icons.category_rounded;
      case DrawerMenu.publishers:
        return Icons.business_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(drawerMenuProvider);

    return Container(
      color: AppColors.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'RAW ',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: 'G',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ...DrawerMenu.values.map((menu) {
                final active = menu == selected;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: active
                        ? AppColors.accent.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        ref.read(drawerMenuProvider.notifier).state = menu;
                        ZoomDrawer.of(context)?.close();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        child: Row(
                          children: [
                            Icon(
                              _iconFor(menu),
                              color: active
                                  ? AppColors.accent
                                  : AppColors.textSecondary,
                              size: 22,
                            ),
                            const SizedBox(width: 14),
                            Text(
                              menu.label,
                              style: TextStyle(
                                color: active
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontSize: 16,
                                fontWeight:
                                    active ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
