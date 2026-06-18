// Models for the `platforms` endpoints.

class PlatformItem {
  int? id;
  String? name;
  String? slug;
  int? gamesCount;
  String? imageBackground;
  String? image;
  int? yearStart;
  int? yearEnd;

  PlatformItem({
    this.id,
    this.name,
    this.slug,
    this.gamesCount,
    this.imageBackground,
    this.image,
    this.yearStart,
    this.yearEnd,
  });

  PlatformItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    gamesCount = json['games_count'];
    imageBackground = json['image_background'];
    image = json['image'];
    yearStart = json['year_start'];
    yearEnd = json['year_end'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['games_count'] = gamesCount;
    data['image_background'] = imageBackground;
    data['image'] = image;
    data['year_start'] = yearStart;
    data['year_end'] = yearEnd;
    return data;
  }
}

/// Returned by `/platforms/lists/parents`.
class PlatformParentSingle {
  int? id;
  String? name;
  String? slug;
  List<PlatformItem>? platforms;

  PlatformParentSingle({this.id, this.name, this.slug, this.platforms});

  PlatformParentSingle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    if (json['platforms'] != null) {
      platforms = <PlatformItem>[];
      json['platforms'].forEach((v) {
        platforms!.add(PlatformItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    if (platforms != null) {
      data['platforms'] = platforms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlatformSingle {
  int? id;
  String? name;
  String? slug;
  int? gamesCount;
  String? imageBackground;
  String? description;
  String? image;
  int? yearStart;
  int? yearEnd;

  PlatformSingle({
    this.id,
    this.name,
    this.slug,
    this.gamesCount,
    this.imageBackground,
    this.description,
    this.image,
    this.yearStart,
    this.yearEnd,
  });

  PlatformSingle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    gamesCount = json['games_count'];
    imageBackground = json['image_background'];
    description = json['description'];
    image = json['image'];
    yearStart = json['year_start'];
    yearEnd = json['year_end'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['games_count'] = gamesCount;
    data['image_background'] = imageBackground;
    data['description'] = description;
    data['image'] = image;
    data['year_start'] = yearStart;
    data['year_end'] = yearEnd;
    return data;
  }
}
