import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/repositories/collection_repository_impl.dart';
import '../../domain/models/collection_game.dart';
import '../../domain/repositories/collection_repository.dart';
import '../../domain/usecases/collection_usecases.dart';
import 'auth_provider.dart';

enum CollectionTab { games, dlc, wishlist, played }

final collectionRepositoryProvider = Provider<CollectionRepository>(
  (ref) => CollectionRepositoryImpl(ref.watch(firestoreProvider)),
);

final watchUserCollectionProvider = Provider<WatchUserCollection>(
  (ref) => WatchUserCollection(ref.watch(collectionRepositoryProvider)),
);

final watchCollectionGameProvider = Provider<WatchCollectionGame>(
  (ref) => WatchCollectionGame(ref.watch(collectionRepositoryProvider)),
);

final addToCollectionProvider = Provider<AddToCollection>(
  (ref) => AddToCollection(ref.watch(collectionRepositoryProvider)),
);

final updateCollectionStatusProvider = Provider<UpdateCollectionStatus>(
  (ref) => UpdateCollectionStatus(ref.watch(collectionRepositoryProvider)),
);

final removeFromCollectionProvider = Provider<RemoveFromCollection>(
  (ref) => RemoveFromCollection(ref.watch(collectionRepositoryProvider)),
);

final collectionTabProvider = StateProvider<CollectionTab>(
  (ref) => CollectionTab.games,
);

final userCollectionProvider = StreamProvider<List<CollectionGame>>((ref) {
  final userId = ref.watch(authStateProvider).value;
  if (userId == null) return Stream.value(const []);

  return ref.watch(watchUserCollectionProvider)(userId);
});

final collectionGameProvider =
    StreamProvider.family<CollectionGame?, int>((ref, gameId) {
  final userId = ref.watch(authStateProvider).value;
  if (userId == null) return Stream.value(null);

  return ref.watch(watchCollectionGameProvider)(userId, gameId);
});

List<CollectionGame> filterCollectionByTab(
  List<CollectionGame> games,
  CollectionTab tab,
) {
  switch (tab) {
    case CollectionTab.games:
      return games;
    case CollectionTab.dlc:
      return const [];
    case CollectionTab.wishlist:
      return games
          .where((game) => game.status == CollectionStatus.wishlist)
          .toList();
    case CollectionTab.played:
      return games
          .where((game) => game.status == CollectionStatus.played)
          .toList();
  }
}

CollectionStats computeCollectionStats(List<CollectionGame> games) {
  if (games.isEmpty) {
    return const CollectionStats(
      totalGames: 0,
      completedCount: 0,
      playedPercent: 0,
    );
  }

  final completed = games
      .where((game) => game.status == CollectionStatus.completed)
      .length;
  final played = games
      .where(
        (game) =>
            game.status == CollectionStatus.played ||
            game.status == CollectionStatus.completed,
      )
      .length;

  return CollectionStats(
    totalGames: games.length,
    completedCount: completed,
    playedPercent: ((played / games.length) * 100).round(),
  );
}

class CollectionStats {
  final int totalGames;
  final int completedCount;
  final int playedPercent;

  const CollectionStats({
    required this.totalGames,
    required this.completedCount,
    required this.playedPercent,
  });
}
