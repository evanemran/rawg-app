import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../app/constants/rawg_discover_filters.dart';
import '../../app/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/drawer_provider.dart';
import 'game_list_page.dart';

class _DrawerItem {
  final IconData icon;
  final String label;
  final DrawerMenu? menu;

  const _DrawerItem(this.icon, this.label, {this.menu});
}

const _mainItems = <_DrawerItem>[
  _DrawerItem(Icons.home_filled, 'Home', menu: DrawerMenu.games),
  _DrawerItem(Icons.emoji_events_outlined, 'Achievements'),
  _DrawerItem(Icons.people_alt_outlined, 'Friends'),
  _DrawerItem(Icons.chat_bubble_outline_rounded, 'Messages'),
  _DrawerItem(Icons.article_outlined, 'News'),
  _DrawerItem(Icons.settings_outlined, 'Settings'),
];

const _discoverItems = <_DrawerItem>[
  _DrawerItem(Icons.star_border_rounded, 'Top Rated', menu: DrawerMenu.topRated),
  _DrawerItem(
    Icons.calendar_today_rounded,
    'New Releases',
    menu: DrawerMenu.newReleases,
  ),
  _DrawerItem(
    Icons.hourglass_empty_rounded,
    'Upcoming',
    menu: DrawerMenu.upcoming,
  ),
  _DrawerItem(Icons.grid_view_rounded, 'Genres', menu: DrawerMenu.genres),
  _DrawerItem(
    Icons.videogame_asset_rounded,
    'Platforms',
    menu: DrawerMenu.platforms,
  ),
  _DrawerItem(
    Icons.business_rounded,
    'Publishers',
    menu: DrawerMenu.publishers,
  ),
];

class DrawerMenuScreen extends ConsumerWidget {
  const DrawerMenuScreen({super.key});

  void _onSelect(BuildContext context, WidgetRef ref, _DrawerItem item) {
    if (item.menu != null) {
      ref.read(drawerMenuProvider.notifier).state = item.menu!;
    }
    ZoomDrawer.of(context)?.close();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(drawerMenuProvider);

    return Material(
      color: AppColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(ref),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._mainItems.map(
                      (item) => _buildItem(context, ref, item, selected),
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.divider, height: 1),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(12, 16, 12, 8),
                      child: Text(
                        'DISCOVER',
                        style: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    ..._discoverItems.map(
                      (item) => _buildItem(context, ref, item, selected),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final displayName = profileAsync.maybeWhen(
      data: (user) => user?.name,
      orElse: () => null,
    );
    final profilePicture = profileAsync.maybeWhen(
      data: (user) => user?.profilePicture,
      orElse: () => null,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.surfaceVariant,
                backgroundImage: profilePicture != null
                    ? NetworkImage(profilePicture)
                    : null,
                child: profilePicture == null
                    ? const Icon(
                        Icons.person_rounded,
                        color: AppColors.textSecondary,
                        size: 30,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName ?? 'Player',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Level 23',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: AppColors.textSecondary,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '3,450 / 5,000 XP',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 3450 / 5000,
              minHeight: 6,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation(AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    WidgetRef ref,
    _DrawerItem item,
    DrawerMenu selected,
  ) {
    final active = item.menu != null && item.menu == selected;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: active
            ? AppColors.accent.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _onSelect(context, ref, item),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: active ? AppColors.accent : AppColors.textSecondary,
                  size: 22,
                ),
                const SizedBox(width: 16),
                Text(
                  item.label,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Convenience builders for Discover filtered game lists used by [AppShell].
class DiscoverGameListPages {
  DiscoverGameListPages._();

  static Widget topRated() {
    return const GameListPage(
      title: 'Top Rated',
      ordering: RawgDiscoverFilters.topRatedOrdering,
      showDrawerButton: true,
    );
  }

  static Widget newReleases() {
    return GameListPage(
      title: 'New Releases',
      ordering: RawgDiscoverFilters.newReleasesOrdering,
      dates: RawgDiscoverFilters.newReleasesDates(),
      showDrawerButton: true,
    );
  }

  static Widget upcoming() {
    return GameListPage(
      title: 'Upcoming',
      ordering: RawgDiscoverFilters.upcomingOrdering,
      dates: RawgDiscoverFilters.upcomingDates(),
      showDrawerButton: true,
    );
  }
}
