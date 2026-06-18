import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../app/theme/app_colors.dart';

class _DrawerItem {
  final IconData icon;
  final String label;

  const _DrawerItem(this.icon, this.label);
}

const _mainItems = <_DrawerItem>[
  _DrawerItem(Icons.home_filled, 'Home'),
  _DrawerItem(Icons.search_rounded, 'Explore'),
  _DrawerItem(Icons.folder_open_rounded, 'Collection'),
  _DrawerItem(Icons.format_list_bulleted_rounded, 'Lists'),
  _DrawerItem(Icons.bookmark_border_rounded, 'Wishlist'),
  _DrawerItem(Icons.schedule_rounded, 'Played'),
  _DrawerItem(Icons.emoji_events_outlined, 'Achievements'),
  _DrawerItem(Icons.people_alt_outlined, 'Friends'),
  _DrawerItem(Icons.chat_bubble_outline_rounded, 'Messages'),
  _DrawerItem(Icons.article_outlined, 'News'),
  _DrawerItem(Icons.settings_outlined, 'Settings'),
];

const _discoverItems = <_DrawerItem>[
  _DrawerItem(Icons.star_border_rounded, 'Top Rated'),
  _DrawerItem(Icons.calendar_today_rounded, 'New Releases'),
  _DrawerItem(Icons.hourglass_empty_rounded, 'Upcoming'),
  _DrawerItem(Icons.grid_view_rounded, 'Genres'),
  _DrawerItem(Icons.videogame_asset_rounded, 'Platforms'),
];

class DrawerMenuScreen extends StatefulWidget {
  const DrawerMenuScreen({super.key});

  @override
  State<DrawerMenuScreen> createState() => _DrawerMenuScreenState();
}

class _DrawerMenuScreenState extends State<DrawerMenuScreen> {
  String _selected = 'Home';

  void _onSelect(String label) {
    setState(() => _selected = label);
    ZoomDrawer.of(context)?.close();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._mainItems.map(_buildItem),
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
                    ..._discoverItems.map(_buildItem),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            /*_buildPremiumCard(),*/
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.surfaceVariant,
                child: Icon(Icons.person_rounded,
                    color: AppColors.textSecondary, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'evanemran',
                      style: TextStyle(
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
                    Row(
                      children: const [
                        Icon(Icons.shield_outlined,
                            color: AppColors.textSecondary, size: 14),
                        SizedBox(width: 4),
                        Expanded(child: Text(
                          '3,450 / 5,000 XP',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              /*const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textSecondary),*/
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

  Widget _buildItem(_DrawerItem item) {
    final active = item.label == _selected;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: active
            ? AppColors.accent.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _onSelect(item.label),
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

  Widget _buildPremiumCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Material(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => ZoomDrawer.of(context)?.close(),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Icon(Icons.workspace_premium_rounded,
                    color: AppColors.accent, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Go Premium',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Unlock exclusive features and support the app',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
