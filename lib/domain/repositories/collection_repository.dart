import '../models/collection_game.dart';

abstract class CollectionRepository {
  Stream<List<CollectionGame>> watchCollection(String userId);

  Stream<CollectionGame?> watchCollectionGame(String userId, int gameId);

  Future<CollectionGame> addToCollection({
    required String userId,
    required CollectionGame game,
  });

  Future<CollectionGame> updateStatus({
    required String userId,
    required int gameId,
    required CollectionStatus status,
  });

  Future<void> removeFromCollection({
    required String userId,
    required int gameId,
  });
}
