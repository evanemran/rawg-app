import '../models/collection_game.dart';
import '../repositories/collection_repository.dart';

class WatchUserCollection {
  final CollectionRepository _repository;

  WatchUserCollection(this._repository);

  Stream<List<CollectionGame>> call(String userId) =>
      _repository.watchCollection(userId);
}

class WatchCollectionGame {
  final CollectionRepository _repository;

  WatchCollectionGame(this._repository);

  Stream<CollectionGame?> call(String userId, int gameId) =>
      _repository.watchCollectionGame(userId, gameId);
}

class AddToCollection {
  final CollectionRepository _repository;

  AddToCollection(this._repository);

  Future<CollectionGame> call({
    required String userId,
    required CollectionGame game,
  }) =>
      _repository.addToCollection(userId: userId, game: game);
}

class UpdateCollectionStatus {
  final CollectionRepository _repository;

  UpdateCollectionStatus(this._repository);

  Future<CollectionGame> call({
    required String userId,
    required int gameId,
    required CollectionStatus status,
  }) =>
      _repository.updateStatus(
        userId: userId,
        gameId: gameId,
        status: status,
      );
}

class RemoveFromCollection {
  final CollectionRepository _repository;

  RemoveFromCollection(this._repository);

  Future<void> call({
    required String userId,
    required int gameId,
  }) =>
      _repository.removeFromCollection(userId: userId, gameId: gameId);
}
