// Models for the `stores` endpoint.

class StoreItem {
  int? id;
  String? name;
  String? domain;
  String? slug;
  int? gamesCount;
  String? imageBackground;

  StoreItem({
    this.id,
    this.name,
    this.domain,
    this.slug,
    this.gamesCount,
    this.imageBackground,
  });

  StoreItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    domain = json['domain'];
    slug = json['slug'];
    gamesCount = json['games_count'];
    imageBackground = json['image_background'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['domain'] = domain;
    data['slug'] = slug;
    data['games_count'] = gamesCount;
    data['image_background'] = imageBackground;
    return data;
  }
}

class StoreSingle {
  int? id;
  String? name;
  String? domain;
  String? slug;
  int? gamesCount;
  String? imageBackground;
  String? description;

  StoreSingle({
    this.id,
    this.name,
    this.domain,
    this.slug,
    this.gamesCount,
    this.imageBackground,
    this.description,
  });

  StoreSingle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    domain = json['domain'];
    slug = json['slug'];
    gamesCount = json['games_count'];
    imageBackground = json['image_background'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['domain'] = domain;
    data['slug'] = slug;
    data['games_count'] = gamesCount;
    data['image_background'] = imageBackground;
    data['description'] = description;
    return data;
  }
}

/// Returned by `/games/{game_pk}/stores`.
class GameStoreFull {
  int? id;
  String? gameId;
  String? storeId;
  String? url;

  GameStoreFull({this.id, this.gameId, this.storeId, this.url});

  GameStoreFull.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gameId = json['game_id']?.toString();
    storeId = json['store_id']?.toString();
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['game_id'] = gameId;
    data['store_id'] = storeId;
    data['url'] = url;
    return data;
  }
}
