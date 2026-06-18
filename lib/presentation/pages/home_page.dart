import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rawg_app/app/theme/app_images.dart';
import 'package:rawg_app/app/theme/app_theme.dart';

import '../../app/theme/app_colors.dart';
import '../../domain/models/games.dart';
import '../../domain/models/genres.dart';
import '../providers/games_provider.dart';
import '../providers/genre_providers.dart';
import '../providers/navigation_provider.dart';
import '../widgets/app_widgets.dart';
import '../widgets/drawer_menu_button.dart';
import '../widgets/game_cards.dart';
import 'game_details_navigation.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesAsync = ref.watch(gamesProvider(1));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(gamesProvider(1));
            ref.invalidate(genresProvider(1));
          },
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const _HomeHeader(),
              _SearchField(
                onTap: () =>
                    ref.read(navigationIndexProvider.notifier).state = 1,
              ),
              const SizedBox(height: 8),
              gamesAsync.when(
                loading: () => const _LoadingBox(height: 360),
                error: (e, _) => _ErrorBox(
                  message: 'Failed to load games.',
                  onRetry: () => ref.invalidate(gamesProvider(1)),
                ),
                data: (games) => _HomeContent(games: games),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  final List<Games> games;

  const _HomeContent({required this.games});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (games.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Text('No games found.',
              style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }

    final featured = games.take(5).toList();
    final popular = games.length > 5 ? games.sublist(5) : games;
    final genresAsync = ref.watch(genresProvider(1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Featured', onViewAll: () {}),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: _FeaturedCarousel(games: featured),
        ),
        const SizedBox(height: 20),
        SectionHeader(title: 'Popular Now', onViewAll: () {}),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: popular.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final game = popular[index];
              return PosterGameCard(
                game: game,
                onTap: () => openGameDetails(context, game),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        SectionHeader(title: 'Browse by Genre', onViewAll: () {}),
        genresAsync.when(
          loading: () => const _LoadingBox(height: 44),
          error: (_, _) => const SizedBox.shrink(),
          data: (genres) => _GenreRow(genres: genres),
        ),
      ],
    );
  }
}

class _GenreRow extends StatelessWidget {
  final List<Genre> genres;

  const _GenreRow({required this.genres});

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: genres.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return GenreChip(label: genres[index].name ?? '');
        },
      ),
    );
  }
}

class _FeaturedCarousel extends StatefulWidget {
  final List<Games> games;

  const _FeaturedCarousel({required this.games});

  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.92);
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: widget.games.length,
            itemBuilder: (context, index) {
              final game = widget.games[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FeaturedGameCard(
                  game: game,
                  onTap: () => openGameDetails(context, game),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.games.length, (i) {
            final active = i == _current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? AppColors.accent : AppColors.divider,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: DrawerMenuButton(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'RAW',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          fontFamily: AppTheme.fontFamily
                        ),
                      ),
                      TextSpan(
                        text: 'G',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          fontFamily: AppTheme.fontFamily
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Explore. Discover. Play.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(AppImages.notificationIcon,
                color: AppColors.textPrimary, height: 24,),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchField({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: const [
              Icon(Icons.search_rounded, color: AppColors.textSecondary),
              SizedBox(width: 10),
              Text(
                'Search games, genres, platforms...',
                style:
                    TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingBox extends StatelessWidget {
  final double height;

  const _LoadingBox({required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBox({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Text(message,
              style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
