import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../data/repositories/collection_repository_impl.dart';
import '../../domain/models/collection_exception.dart';
import '../../domain/models/collection_game.dart';
import '../../domain/models/games.dart';
import '../providers/auth_provider.dart';
import '../providers/collection_provider.dart';

class CollectionActionBar extends ConsumerStatefulWidget {
  final Games game;

  const CollectionActionBar({super.key, required this.game});

  @override
  ConsumerState<CollectionActionBar> createState() =>
      _CollectionActionBarState();
}

class _CollectionActionBarState extends ConsumerState<CollectionActionBar> {
  bool _isBusy = false;

  int? get _gameId => widget.game.id;

  Future<void> _addToCollection() async {
    final userId = ref.read(firebaseAuthProvider).currentUser?.uid ??
        ref.read(authStateProvider).value;
    final gameId = _gameId;
    if (userId == null) {
      _showMessage('You must be signed in to add games.');
      return;
    }
    if (gameId == null || gameId <= 0) {
      _showMessage('Invalid game. Could not add to collection.');
      return;
    }

    setState(() => _isBusy = true);
    try {
      final entry = CollectionRepositoryImpl.fromGames(widget.game);
      await ref.read(addToCollectionProvider)(
        userId: userId,
        game: entry,
      );
    } on CollectionException catch (e) {
      _showMessage(e.message);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _updateStatus(CollectionStatus status) async {
    final userId = ref.read(firebaseAuthProvider).currentUser?.uid ??
        ref.read(authStateProvider).value;
    final gameId = _gameId;
    if (userId == null || gameId == null) return;

    setState(() => _isBusy = true);
    try {
      await ref.read(updateCollectionStatusProvider)(
        userId: userId,
        gameId: gameId,
        status: status,
      );
    } on CollectionException catch (e) {
      _showMessage(e.message);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameId = _gameId;
    if (gameId == null) return const SizedBox.shrink();

    final collectionAsync = ref.watch(collectionGameProvider(gameId));
    final inCollection = collectionAsync.value != null;
    final status = collectionAsync.value?.status ?? CollectionStatus.wishlist;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: _CollectionButton(
              label: inCollection ? 'Collection' : 'Collection',
              icon: inCollection ? Icons.check_rounded : Icons.add_rounded,
              filled: true,
              isLoading: _isBusy,
              onPressed: inCollection ? null : _addToCollection,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: _StatusDropdownButton(
              status: status,
              enabled: inCollection && !_isBusy,
              onStatusSelected: _updateStatus,
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _CollectionButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: FilledButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor:
              filled ? AppColors.accent : AppColors.surface,
          disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.7),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _StatusDropdownButton extends StatelessWidget {
  final CollectionStatus status;
  final bool enabled;
  final ValueChanged<CollectionStatus> onStatusSelected;

  const _StatusDropdownButton({
    required this.status,
    required this.enabled,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CollectionStatus>(
      enabled: enabled,
      onSelected: onStatusSelected,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, 48),
      itemBuilder: (context) => CollectionStatus.values
          .map(
            (value) => PopupMenuItem(
              value: value,
              child: Text(
                value.label,
                style: TextStyle(
                  color: value == status
                      ? AppColors.accent
                      : AppColors.textPrimary,
                  fontWeight:
                      value == status ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled ? AppColors.divider : AppColors.divider.withValues(
              alpha: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 18,
              color: enabled ? AppColors.textPrimary : AppColors.textTertiary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                status.label,
                style: TextStyle(
                  color: enabled
                      ? AppColors.textPrimary
                      : AppColors.textTertiary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: enabled ? AppColors.textSecondary : AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
