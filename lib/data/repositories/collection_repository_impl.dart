import 'package:cloud_firestore/cloud_firestore.dart';

import '../../app/constants/firebase_constants.dart';
import '../../domain/models/collection_exception.dart';
import '../../domain/models/collection_game.dart';
import '../../domain/models/games.dart';
import '../../domain/repositories/collection_repository.dart';

class CollectionRepositoryImpl implements CollectionRepository {
  final FirebaseFirestore _firestore;

  CollectionRepositoryImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> _collectionRef(String userId) {
    return _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.collectionSubcollection);
  }

  @override
  Stream<List<CollectionGame>> watchCollection(String userId) {
    return _collectionRef(userId)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => _fromFirestore(doc.id, doc.data()))
              .whereType<CollectionGame>()
              .toList(),
        );
  }

  @override
  Stream<CollectionGame?> watchCollectionGame(String userId, int gameId) {
    return _collectionRef(userId)
        .doc(gameId.toString())
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      final data = doc.data();
      if (data == null) return null;
      return _fromFirestore(doc.id, data);
    });
  }

  @override
  Future<CollectionGame> addToCollection({
    required String userId,
    required CollectionGame game,
  }) async {
    if (game.gameId <= 0) {
      throw const CollectionException('Invalid game. Could not add to collection.');
    }

    try {
      final docRef = _collectionRef(userId).doc(game.gameId.toString());
      final existing = await docRef.get();
      if (existing.exists) {
        final data = existing.data();
        if (data != null) {
          final current = _fromFirestore(existing.id, data);
          if (current != null) return current;
        }
      }

      await docRef.set(_toFirestore(game));
      return game;
    } on CollectionException {
      rethrow;
    } on FirebaseException catch (e) {
      throw CollectionException(_mapFirebaseError(e));
    } catch (_) {
      throw const CollectionException('Could not add game to collection.');
    }
  }

  @override
  Future<CollectionGame> updateStatus({
    required String userId,
    required int gameId,
    required CollectionStatus status,
  }) async {
    try {
      final docRef = _collectionRef(userId).doc(gameId.toString());
      final doc = await docRef.get();
      if (!doc.exists) {
        throw const CollectionException('Game is not in your collection.');
      }

      await docRef.update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final updated = await docRef.get();
      final game = _fromFirestore(updated.id, updated.data()!);
      if (game == null) {
        throw const CollectionException('Could not update collection status.');
      }
      return game;
    } on CollectionException {
      rethrow;
    } on FirebaseException catch (e) {
      throw CollectionException(_mapFirebaseError(e));
    } catch (_) {
      throw const CollectionException('Could not update collection status.');
    }
  }

  @override
  Future<void> removeFromCollection({
    required String userId,
    required int gameId,
  }) async {
    try {
      await _collectionRef(userId).doc(gameId.toString()).delete();
    } on FirebaseException catch (e) {
      throw CollectionException(_mapFirebaseError(e));
    } catch (_) {
      throw const CollectionException('Could not remove game from collection.');
    }
  }

  static CollectionGame fromGames(
    Games game, {
    CollectionStatus status = CollectionStatus.wishlist,
  }) {
    return CollectionGame(
      gameId: game.id ?? 0,
      name: game.name ?? 'Unknown',
      slug: game.slug,
      backgroundImage: game.backgroundImage,
      released: game.released,
      genre: (game.genres != null && game.genres!.isNotEmpty)
          ? game.genres!.first.name
          : null,
      rating: game.rating,
      status: status,
      addedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> _toFirestore(CollectionGame game) {
    return {
      'gameId': game.gameId,
      'name': game.name,
      'status': game.status.name,
      'addedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      if (game.slug != null) 'slug': game.slug,
      if (game.backgroundImage != null) 'backgroundImage': game.backgroundImage,
      if (game.released != null) 'released': game.released,
      if (game.genre != null) 'genre': game.genre,
      if (game.rating != null) 'rating': game.rating,
    };
  }

  String _mapFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Permission denied. Update Firestore rules for the collection subcollection.';
      case 'unavailable':
        return 'Firestore is unavailable. Check your connection and try again.';
      default:
        return e.message ?? 'Firestore error (${e.code}).';
    }
  }

  CollectionGame? _fromFirestore(String docId, Map<String, dynamic> data) {
    final addedAt = data['addedAt'];
    if (addedAt is! Timestamp) return null;

    return CollectionGame(
      gameId: data['gameId'] as int? ?? int.tryParse(docId) ?? 0,
      name: data['name'] as String? ?? '',
      slug: data['slug'] as String?,
      backgroundImage: data['backgroundImage'] as String?,
      released: data['released'] as String?,
      genre: data['genre'] as String?,
      rating: (data['rating'] as num?)?.toDouble(),
      status: CollectionStatus.fromString(
        data['status'] as String? ?? CollectionStatus.wishlist.name,
      ),
      addedAt: addedAt.toDate(),
    );
  }
}
