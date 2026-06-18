// Models for the `publishers` endpoint.

class Publisher {
  int? id;
  String? name;
  String? slug;
  int? gamesCount;
  String? imageBackground;

  Publisher({
    this.id,
    this.name,
    this.slug,
    this.gamesCount,
    this.imageBackground,
  });

  Publisher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    gamesCount = json['games_count'];
    imageBackground = json['image_background'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['games_count'] = gamesCount;
    data['image_background'] = imageBackground;
    return data;
  }
}

class PublisherSingle {
  int? id;
  String? name;
  String? slug;
  int? gamesCount;
  String? imageBackground;
  String? description;

  PublisherSingle({
    this.id,
    this.name,
    this.slug,
    this.gamesCount,
    this.imageBackground,
    this.description,
  });

  PublisherSingle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    gamesCount = json['games_count'];
    imageBackground = json['image_background'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['games_count'] = gamesCount;
    data['image_background'] = imageBackground;
    data['description'] = description;
    return data;
  }
}
