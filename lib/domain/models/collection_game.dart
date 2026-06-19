import 'games.dart';

enum CollectionStatus {
  wishlist,
  played,
  completed;

  String get label {
    switch (this) {
      case CollectionStatus.wishlist:
        return 'Wishlist';
      case CollectionStatus.played:
        return 'Played';
      case CollectionStatus.completed:
        return 'Completed';
    }
  }

  static CollectionStatus fromString(String value) {
    return CollectionStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => CollectionStatus.wishlist,
    );
  }
}

class CollectionGame {
  final int gameId;
  final String name;
  final String? slug;
  final String? backgroundImage;
  final String? released;
  final String? genre;
  final double? rating;
  final CollectionStatus status;
  final DateTime addedAt;

  const CollectionGame({
    required this.gameId,
    required this.name,
    this.slug,
    this.backgroundImage,
    this.released,
    this.genre,
    this.rating,
    required this.status,
    required this.addedAt,
  });

  CollectionGame copyWith({
    String? name,
    String? slug,
    String? backgroundImage,
    String? released,
    String? genre,
    double? rating,
    CollectionStatus? status,
    DateTime? addedAt,
  }) {
    return CollectionGame(
      gameId: gameId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      released: released ?? this.released,
      genre: genre ?? this.genre,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Games toGames() {
    return Games(
      id: gameId,
      name: name,
      slug: slug,
      backgroundImage: backgroundImage,
      released: released,
      rating: rating,
      genres: genre != null ? [Genres(name: genre)] : null,
    );
  }
}
