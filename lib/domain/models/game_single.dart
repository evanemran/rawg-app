// Model for `/games/{id}` (game details) and `/games/{id}/suggested`.

import 'package:rawg_app/domain/models/developers.dart';

class GamePlatformMetacritic {
  int? metascore;
  String? url;

  GamePlatformMetacritic({this.metascore, this.url});

  GamePlatformMetacritic.fromJson(Map<String, dynamic> json) {
    metascore = json['metascore'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['metascore'] = metascore;
    data['url'] = url;
    return data;
  }
}

class EsrbRating {
  int? id;
  String? slug;
  String? name;

  EsrbRating({this.id, this.slug, this.name});

  EsrbRating.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['name'] = name;
    return data;
  }
}

class GameSingle {
  int? id;
  String? slug;
  String? name;
  String? nameOriginal;
  String? description;
  int? metacritic;
  List<GamePlatformMetacritic>? metacriticPlatforms;
  String? released;
  bool? tba;
  String? updated;
  String? backgroundImage;
  String? backgroundImageAdditional;
  String? website;
  double? rating;
  int? ratingTop;
  int? added;
  int? playtime;
  int? screenshotsCount;
  int? moviesCount;
  int? creatorsCount;
  int? achievementsCount;
  String? parentAchievementsCount;
  String? redditUrl;
  String? redditName;
  String? redditDescription;
  String? redditLogo;
  int? redditCount;
  String? twitchCount;
  String? youtubeCount;
  String? reviewsTextCount;
  int? ratingsCount;
  int? suggestionsCount;
  List<String>? alternativeNames;
  String? metacriticUrl;
  int? parentsCount;
  int? additionsCount;
  int? gameSeriesCount;
  EsrbRating? esrbRating;
  List<Developer>? developers;

  GameSingle({
    this.id,
    this.slug,
    this.name,
    this.nameOriginal,
    this.description,
    this.metacritic,
    this.metacriticPlatforms,
    this.released,
    this.tba,
    this.updated,
    this.backgroundImage,
    this.backgroundImageAdditional,
    this.website,
    this.rating,
    this.ratingTop,
    this.added,
    this.playtime,
    this.screenshotsCount,
    this.moviesCount,
    this.creatorsCount,
    this.achievementsCount,
    this.parentAchievementsCount,
    this.redditUrl,
    this.redditName,
    this.redditDescription,
    this.redditLogo,
    this.redditCount,
    this.twitchCount,
    this.youtubeCount,
    this.reviewsTextCount,
    this.ratingsCount,
    this.suggestionsCount,
    this.alternativeNames,
    this.metacriticUrl,
    this.parentsCount,
    this.additionsCount,
    this.gameSeriesCount,
    this.esrbRating,
    this.developers,
  });

  GameSingle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    nameOriginal = json['name_original'];
    description = json['description'];
    metacritic = json['metacritic'];
    if (json['metacritic_platforms'] != null) {
      metacriticPlatforms = <GamePlatformMetacritic>[];
      json['metacritic_platforms'].forEach((v) {
        metacriticPlatforms!.add(GamePlatformMetacritic.fromJson(v));
      });
    }
    released = json['released'];
    tba = json['tba'];
    updated = json['updated'];
    backgroundImage = json['background_image'];
    backgroundImageAdditional = json['background_image_additional'];
    website = json['website'];
    rating = (json['rating'] as num?)?.toDouble();
    ratingTop = json['rating_top'];
    added = json['added'];
    playtime = json['playtime'];
    screenshotsCount = json['screenshots_count'];
    moviesCount = json['movies_count'];
    creatorsCount = json['creators_count'];
    achievementsCount = json['achievements_count'];
    parentAchievementsCount = json['parent_achievements_count']?.toString();
    redditUrl = json['reddit_url'];
    redditName = json['reddit_name'];
    redditDescription = json['reddit_description'];
    redditLogo = json['reddit_logo'];
    redditCount = json['reddit_count'];
    twitchCount = json['twitch_count']?.toString();
    youtubeCount = json['youtube_count']?.toString();
    reviewsTextCount = json['reviews_text_count']?.toString();
    ratingsCount = json['ratings_count'];
    suggestionsCount = json['suggestions_count'];
    alternativeNames = (json['alternative_names'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList();
    metacriticUrl = json['metacritic_url'];
    parentsCount = json['parents_count'];
    additionsCount = json['additions_count'];
    gameSeriesCount = json['game_series_count'];
    esrbRating = json['esrb_rating'] != null
        ? EsrbRating.fromJson(json['esrb_rating'])
        : null;
    if (json['developers'] != null) {
      developers = <Developer>[];
      json['developers'].forEach((v) {
        developers!.add(Developer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['name'] = name;
    data['name_original'] = nameOriginal;
    data['description'] = description;
    data['metacritic'] = metacritic;
    if (metacriticPlatforms != null) {
      data['metacritic_platforms'] =
          metacriticPlatforms!.map((v) => v.toJson()).toList();
    }
    data['released'] = released;
    data['tba'] = tba;
    data['updated'] = updated;
    data['background_image'] = backgroundImage;
    data['background_image_additional'] = backgroundImageAdditional;
    data['website'] = website;
    data['rating'] = rating;
    data['rating_top'] = ratingTop;
    data['added'] = added;
    data['playtime'] = playtime;
    data['screenshots_count'] = screenshotsCount;
    data['movies_count'] = moviesCount;
    data['creators_count'] = creatorsCount;
    data['achievements_count'] = achievementsCount;
    data['parent_achievements_count'] = parentAchievementsCount;
    data['reddit_url'] = redditUrl;
    data['reddit_name'] = redditName;
    data['reddit_description'] = redditDescription;
    data['reddit_logo'] = redditLogo;
    data['reddit_count'] = redditCount;
    data['twitch_count'] = twitchCount;
    data['youtube_count'] = youtubeCount;
    data['reviews_text_count'] = reviewsTextCount;
    data['ratings_count'] = ratingsCount;
    data['suggestions_count'] = suggestionsCount;
    data['alternative_names'] = alternativeNames;
    data['metacritic_url'] = metacriticUrl;
    data['parents_count'] = parentsCount;
    data['additions_count'] = additionsCount;
    data['game_series_count'] = gameSeriesCount;
    if (esrbRating != null) {
      data['esrb_rating'] = esrbRating!.toJson();
    }
    if (developers != null) {
      data['developers'] = developers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
