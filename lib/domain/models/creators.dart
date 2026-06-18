// Models for the `creator-roles` and `creators` endpoints.

class Position {
  int? id;
  String? name;
  String? slug;

  Position({this.id, this.name, this.slug});

  Position.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}

class Person {
  int? id;
  String? name;
  String? slug;
  String? image;
  String? imageBackground;
  int? gamesCount;

  Person({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.imageBackground,
    this.gamesCount,
  });

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    imageBackground = json['image_background'];
    gamesCount = json['games_count'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['image'] = image;
    data['image_background'] = imageBackground;
    data['games_count'] = gamesCount;
    return data;
  }
}

class PersonSingle {
  int? id;
  String? name;
  String? slug;
  String? image;
  String? imageBackground;
  String? description;
  int? gamesCount;
  int? reviewsCount;
  String? rating;
  int? ratingTop;
  String? updated;

  PersonSingle({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.imageBackground,
    this.description,
    this.gamesCount,
    this.reviewsCount,
    this.rating,
    this.ratingTop,
    this.updated,
  });

  PersonSingle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    imageBackground = json['image_background'];
    description = json['description'];
    gamesCount = json['games_count'];
    reviewsCount = json['reviews_count'];
    rating = json['rating'];
    ratingTop = json['rating_top'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['image'] = image;
    data['image_background'] = imageBackground;
    data['description'] = description;
    data['games_count'] = gamesCount;
    data['reviews_count'] = reviewsCount;
    data['rating'] = rating;
    data['rating_top'] = ratingTop;
    data['updated'] = updated;
    return data;
  }
}

/// Returned by `/games/{game_pk}/development-team`.
class GamePersonList {
  int? id;
  String? name;
  String? slug;
  String? image;
  String? imageBackground;
  int? gamesCount;

  GamePersonList({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.imageBackground,
    this.gamesCount,
  });

  GamePersonList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    imageBackground = json['image_background'];
    gamesCount = json['games_count'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['image'] = image;
    data['image_background'] = imageBackground;
    data['games_count'] = gamesCount;
    return data;
  }
}
