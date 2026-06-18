import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_images.dart';
import '../providers/navigation_provider.dart';
import 'collection_page.dart';
import 'explore_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  static const List<Widget> _pages = [
    HomePage(),
    ExplorePage(),
    CollectionPage(),
    ProfilePage(),
  ];

  static List<_NavItem> _items = [
    _NavItem(icon: AppImages.homeInactive, activeIcon: AppImages.homeActive, label: 'Home'),
    _NavItem(icon: AppImages.exploreInactive, activeIcon: AppImages.exploreActive, label: 'Explore'),
    _NavItem(
        icon: AppImages.collectionInactive,
        activeIcon: AppImages.collectionActive,
        label: 'Collection'),
    _NavItem(
        icon: AppImages.profileInactive,
        activeIcon: AppImages.profileActive,
        label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _BottomNav(
        items: _items,
        currentIndex: currentIndex,
        onTap: (index) =>
            ref.read(navigationIndexProvider.notifier).state = index,
      ),
    );
  }
}

class _NavItem {
  final String icon;
  final String activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _BottomNav extends StatelessWidget {
  final List<_NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final active = index == currentIndex;
              final color =
                  active ? AppColors.accent : AppColors.textSecondary;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(active ? item.activeIcon : item.icon,
                          color: color, height: 24),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight:
                              active ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
