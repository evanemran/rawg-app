// Models for game sub-resources: screenshots, achievements, movies,
// reddit posts, twitch and youtube videos.

class ScreenShot {
  int? id;
  String? image;
  bool? hidden;
  int? width;
  int? height;

  ScreenShot({this.id, this.image, this.hidden, this.width, this.height});

  ScreenShot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    hidden = json['hidden'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['hidden'] = hidden;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}

class ParentAchievement {
  int? id;
  String? name;
  String? description;
  String? image;
  String? percent;

  ParentAchievement({
    this.id,
    this.name,
    this.description,
    this.image,
    this.percent,
  });

  ParentAchievement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    percent = json['percent']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['percent'] = percent;
    return data;
  }
}

class Movie {
  int? id;
  String? name;
  String? preview;
  Map<String, dynamic>? data;

  Movie({this.id, this.name, this.preview, this.data});

  Movie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    preview = json['preview'];
    data = json['data'] != null
        ? Map<String, dynamic>.from(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['preview'] = preview;
    map['data'] = data;
    return map;
  }
}

class Reddit {
  int? id;
  String? name;
  String? text;
  String? image;
  String? url;
  String? username;
  String? usernameUrl;
  String? created;

  Reddit({
    this.id,
    this.name,
    this.text,
    this.image,
    this.url,
    this.username,
    this.usernameUrl,
    this.created,
  });

  Reddit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    text = json['text'];
    image = json['image'];
    url = json['url'];
    username = json['username'];
    usernameUrl = json['username_url'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['text'] = text;
    data['image'] = image;
    data['url'] = url;
    data['username'] = username;
    data['username_url'] = usernameUrl;
    data['created'] = created;
    return data;
  }
}

class Twitch {
  int? id;
  int? externalId;
  String? name;
  String? description;
  String? created;
  String? published;
  String? thumbnail;
  int? viewCount;
  String? language;

  Twitch({
    this.id,
    this.externalId,
    this.name,
    this.description,
    this.created,
    this.published,
    this.thumbnail,
    this.viewCount,
    this.language,
  });

  Twitch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    externalId = json['external_id'];
    name = json['name'];
    description = json['description'];
    created = json['created'];
    published = json['published'];
    thumbnail = json['thumbnail'];
    viewCount = json['view_count'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['external_id'] = externalId;
    data['name'] = name;
    data['description'] = description;
    data['created'] = created;
    data['published'] = published;
    data['thumbnail'] = thumbnail;
    data['view_count'] = viewCount;
    data['language'] = language;
    return data;
  }
}

class Youtube {
  int? id;
  String? externalId;
  String? channelId;
  String? channelTitle;
  String? name;
  String? description;
  String? created;
  int? viewCount;
  int? commentsCount;
  int? likeCount;
  int? dislikeCount;
  int? favoriteCount;
  Map<String, dynamic>? thumbnails;

  Youtube({
    this.id,
    this.externalId,
    this.channelId,
    this.channelTitle,
    this.name,
    this.description,
    this.created,
    this.viewCount,
    this.commentsCount,
    this.likeCount,
    this.dislikeCount,
    this.favoriteCount,
    this.thumbnails,
  });

  Youtube.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    externalId = json['external_id'];
    channelId = json['channel_id'];
    channelTitle = json['channel_title'];
    name = json['name'];
    description = json['description'];
    created = json['created'];
    viewCount = json['view_count'];
    commentsCount = json['comments_count'];
    likeCount = json['like_count'];
    dislikeCount = json['dislike_count'];
    favoriteCount = json['favorite_count'];
    thumbnails = json['thumbnails'] != null
        ? Map<String, dynamic>.from(json['thumbnails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['external_id'] = externalId;
    data['channel_id'] = channelId;
    data['channel_title'] = channelTitle;
    data['name'] = name;
    data['description'] = description;
    data['created'] = created;
    data['view_count'] = viewCount;
    data['comments_count'] = commentsCount;
    data['like_count'] = likeCount;
    data['dislike_count'] = dislikeCount;
    data['favorite_count'] = favoriteCount;
    data['thumbnails'] = thumbnails;
    return data;
  }
}
