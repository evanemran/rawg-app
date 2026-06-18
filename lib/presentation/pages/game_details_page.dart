import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_colors.dart';
import '../../domain/models/game_single.dart';
import '../../domain/models/games.dart';
import '../providers/game_providers.dart';
import '../widgets/app_widgets.dart';

class GameDetailsPage extends ConsumerStatefulWidget {
  final Games game;

  const GameDetailsPage({super.key, required this.game});

  @override
  ConsumerState<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends ConsumerState<GameDetailsPage> {
  bool _descriptionExpanded = false;
  bool _favorite = false;

  Games get game => widget.game;

  String _stripHtml(String input) {
    return input
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final detailsAsync = ref.watch(gameDetailsProvider(game.id.toString()));
    final details = detailsAsync.asData?.value;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),
              _buildTitleBlock(details),
              const SizedBox(height: 20),
              _buildStats(),
              const SizedBox(height: 20),
              _buildGenres(),
              _buildDescription(detailsAsync),
              const SizedBox(height: 24),
              _buildInformation(details),
              _buildRatingsBreakdown(),
              _buildPlatforms(),
              const SizedBox(height: 24),
              _buildStores(),
              _buildScreenshots(),
              const SizedBox(height: 24),
              _buildTags(),
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: _circleButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.of(context).maybePop(),
      ),
      actions: [
        _circleButton(icon: Icons.ios_share_rounded, onTap: () {}),
        _circleButton(
          icon: _favorite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          color: _favorite ? AppColors.accent : null,
          onTap: () => setState(() => _favorite = !_favorite),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            GameImage(url: game.backgroundImage),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black54,
                    Colors.transparent,
                    AppColors.background,
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Material(
        color: Colors.black.withValues(alpha: 0.35),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 18, color: color ?? Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBlock(GameSingle? details) {
    final genre = (game.genres != null && game.genres!.isNotEmpty)
        ? game.genres!.first.name
        : null;
    final year = gameYear(game.released);
    final meta = [year, genre].whereType<String>().join('  ·  ');
    final developer =
        (details?.developers != null && details!.developers!.isNotEmpty)
        ? details.developers!.first.name
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GameImage(url: game.backgroundImage, width: 92, height: 122),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.name ?? '',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                if (meta.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    meta,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (developer != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    developer.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _statItem(
            value: game.metacritic?.toString() ?? '—',
            label: 'Metacritic',
            showStar: true,
          ),
          _statDivider(),
          _statItem(
            value: game.rating != null ? '${game.rating}/5' : '—',
            label: 'Rating',
          ),
          _statDivider(),
          _statItem(
            value: game.playtime != null && game.playtime! > 0
                ? '${game.playtime}h'
                : '—',
            label: 'Playtime',
          ),
        ],
      ),
    );
  }

  Widget _statDivider() =>
      Container(width: 1, height: 34, color: AppColors.divider);

  Widget _statItem({
    required String value,
    required String label,
    bool showStar = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showStar) ...[
                const Icon(Icons.star_rounded, color: AppColors.star, size: 18),
                const SizedBox(width: 4),
              ],
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(AsyncValue<GameSingle> detailsAsync) {
    return detailsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (details) {
        final raw = details.description;
        if (raw == null || raw.trim().isEmpty) return const SizedBox.shrink();
        final text = _stripHtml(raw);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'About'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.topCenter,
                    child: Text(
                      text,
                      maxLines: _descriptionExpanded ? null : 4,
                      overflow: _descriptionExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => setState(
                      () => _descriptionExpanded = !_descriptionExpanded,
                    ),
                    child: Text(
                      _descriptionExpanded ? 'Read less' : 'Read more',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGenres() {
    final genres = game.genres;
    if (genres == null || genres.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: genres.map((g) => _pill(g.name ?? '', accent: true)).toList(),
      ),
    );
  }

  Widget _buildInformation(GameSingle? details) {
    final released = _formatDate(game.released);
    final developer =
        (details?.developers != null && details!.developers!.isNotEmpty)
        ? details.developers!.map((d) => d.name).whereType<String>().join(', ')
        : null;
    final esrb = game.esrbRating?.name ?? details?.esrbRating?.name;
    final website = details?.website;
    final updated = _formatDate(details?.updated ?? game.updated);

    final rows = <Widget>[
      if (released != null) _infoRow('Release date', released),
      if (developer != null) _infoRow('Developer', developer),
      if (esrb != null) _infoRow('Age rating', esrb),
      if (game.playtime != null && game.playtime! > 0)
        _infoRow('Average playtime', '${game.playtime} hours'),
      if (website != null && website.isNotEmpty) _infoRow('Website', website),
      if (updated != null) _infoRow('Last updated', updated),
    ];

    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Information'),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(children: rows),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingsBreakdown() {
    final ratings = game.ratings;
    if (ratings == null || ratings.isEmpty) return const SizedBox.shrink();

    final total = ratings.fold<int>(0, (sum, r) => sum + (r.count ?? 0));
    if (total == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Ratings'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            children: ratings.map((r) {
              final fraction = (r.count ?? 0) / total;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 96,
                      child: Text(
                        _capitalize(r.title ?? ''),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: fraction,
                          minHeight: 8,
                          backgroundColor: AppColors.surfaceVariant,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.accent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 52,
                      child: Text(
                        '${r.count}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStores() {
    final stores = game.stores;
    if (stores == null || stores.isEmpty) return const SizedBox.shrink();
    final names = stores.map((s) => s.store?.name).whereType<String>().toList();
    if (names.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Where to buy'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: names
                .map((n) => _pill(n, icon: Icons.storefront_rounded))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    final tags = game.tags;
    if (tags == null || tags.isEmpty) return const SizedBox.shrink();
    final names = tags
        .where((t) => t.language == null || t.language == 'eng')
        .map((t) => t.name)
        .whereType<String>()
        .take(15)
        .toList();
    if (names.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Tags'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: names.map((n) => _pill(n)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _pill(String label, {bool accent = false, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accent
              ? AppColors.accent.withValues(alpha: 0.5)
              : AppColors.divider,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: accent ? AppColors.accentSoft : AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  String? _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final date = DateTime.tryParse(raw);
    if (date == null) return raw;
    return DateFormat('MMM d, yyyy').format(date);
  }

  Widget _buildPlatforms() {
    final platforms = game.parentPlatforms;
    if (platforms == null || platforms.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            'Platforms',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 78,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: platforms.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final p = platforms[index].platform;
              return Container(
                width: 88,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      platformIcon(p?.slug),
                      color: AppColors.textPrimary,
                      size: 22,
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        p?.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildScreenshots() {
    final shots = game.shortScreenshots;
    if (shots == null || shots.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Screenshots'),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: shots.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GameImage(
                  url: shots[index].image,
                  width: 220,
                  height: 140,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
