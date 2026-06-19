import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_colors.dart';
import '../../domain/models/auth_exception.dart';
import '../providers/auth_provider.dart';
import '../widgets/profile_widgets.dart';
import '../widgets/shimmer_widgets.dart';

/// Placeholder stats and activity until collection/achievement features ship.
class _ProfilePlaceholderData {
  static const stats = [
    (value: '128', label: 'Games'),
    (value: '32', label: 'Completed'),
    (value: '244', label: 'Achievements'),
    (value: '560h', label: 'Playtime'),
  ];

  static const genres = [
    (name: 'RPG', count: '35 games', progress: 0.88),
    (name: 'Action', count: '28 games', progress: 0.72),
    (name: 'Indie', count: '16 games', progress: 0.45),
  ];

  static const baldursGateThumb =
      'https://media.rawg.io/media/games/26/0/26050c190f7da5a8f5e873046bcbdaa4.jpg';
  static const hadesThumb =
      'https://media.rawg.io/media/games/1b4/1b43f100edca9d409216be2e7de12306.jpg';
  static const eldenLordThumb =
      'https://media.rawg.io/media/games/5ec/5ecac5cb026ec26a56efcc546364e348.jpg';
}

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: profileAsync.when(
          loading: () => const _ProfileLoading(),
          error: (_, _) => const _ProfileError(),
          data: (user) {
            if (user == null) {
              return const _ProfileError();
            }
            return _ProfileContent(
              name: user.name,
              imageUrl: user.profilePicture,
              memberSince: DateFormat('MMMM yyyy').format(user.joiningDate),
              onSettingsTap: () => _showSettingsSheet(context, ref),
              onEditAvatarTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile photo editing coming soon.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.textPrimary,
                  ),
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await _signOut(context, ref);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(signOutProvider)();
    } on AuthException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }
}

class _ProfileContent extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String memberSince;
  final VoidCallback onSettingsTap;
  final VoidCallback onEditAvatarTap;

  const _ProfileContent({
    required this.name,
    required this.imageUrl,
    required this.memberSince,
    required this.onSettingsTap,
    required this.onEditAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: ProfileHeader(onSettingsTap: onSettingsTap)),
        SliverToBoxAdapter(
          child: Column(
            children: [
              ProfileAvatar(
                imageUrl: imageUrl,
                onEditTap: onEditAvatarTap,
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Member since $memberSince',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: _ProfilePlaceholderData.stats
                      .map(
                        (stat) => ProfileStatItem(
                          value: stat.value,
                          label: stat.label,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: ProfileSectionHeader(
            title: 'Recent Activity',
            actionLabel: 'View all',
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              ProfileActivityRow(
                leading: const ProfileAchievementIcon(),
                title: 'Earned an achievement',
                subtitle: 'Elden Ring',
                trailing: '2h ago',
              ),
              ProfileAchievementCard(
                imageUrl: _ProfilePlaceholderData.eldenLordThumb,
                title: 'Elden Lord',
                description: "Achieved the 'Elden Lord' ending",
                rarity: 'Rare · 1.6%',
              ),
              ProfileActivityRow(
                leading: ProfileGameThumb(
                  imageUrl: _ProfilePlaceholderData.baldursGateThumb,
                ),
                title: 'Added to collection',
                subtitle: "Baldur's Gate 3",
                trailing: '5h ago',
              ),
              ProfileActivityRow(
                leading: ProfileGameThumb(
                  imageUrl: _ProfilePlaceholderData.hadesThumb,
                ),
                title: 'Completed',
                subtitle: 'Hades II',
                trailingWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      '1d ago',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          color: AppColors.textSecondary,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '84%',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: ProfileSectionHeader(
            title: 'Favorite Genres',
            actionLabel: 'View stats',
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              final genre = _ProfilePlaceholderData.genres[index];
              return ProfileGenreBar(
                genre: genre.name,
                countLabel: genre.count,
                progress: genre.progress,
              );
            },
            childCount: _ProfilePlaceholderData.genres.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _ProfileLoading extends StatelessWidget {
  const _ProfileLoading();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: ProfileHeader()),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 8),
                ShimmerBox(
                  width: 110,
                  height: 110,
                  borderRadius: BorderRadius.all(Radius.circular(55)),
                ),
                SizedBox(height: 16),
                ShimmerBox(
                  width: 140,
                  height: 22,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                SizedBox(height: 8),
                ShimmerBox(
                  width: 160,
                  height: 14,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ShimmerBox(
                          height: 40,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ShimmerBox(
                          height: 40,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ShimmerBox(
                          height: 40,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ShimmerBox(
                          height: 40,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Could not load profile.',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
