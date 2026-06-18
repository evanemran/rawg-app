// Models for the `tags` endpoint.

class Tag {
  int? id;
  String? name;
  String? slug;
  int? gamesCount;
  String? imageBackground;
  String? language;

  Tag({
    this.id,
    this.name,
    this.slug,
    this.gamesCount,
    this.imageBackground,
    this.language,
  });

  Tag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    gamesCount = json['games_count'];
    imageBackground = json['image_background'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['games_count'] = gamesCount;
    data['image_background'] = imageBackground;
    data['language'] = language;
    return data;
  }
}

class TagSingle {
  int? id;
  String? name;
  String? slug;
  int? gamesCount;
  String? imageBackground;
  String? description;

  TagSingle({
    this.id,
    this.name,
    this.slug,
    this.gamesCount,
    this.imageBackground,
    this.description,
  });

  TagSingle.fromJson(Map<String, dynamic> json) {
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
