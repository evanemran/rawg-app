import 'package:rawg_app/domain/models/games.dart';

class GamesResponse {
  int? count;
  String? next;
  String? previous;
  List<Games>? results;
  String? seoTitle;
  String? seoDescription;
  String? seoKeywords;
  String? seoH1;
  bool? noindex;
  bool? nofollow;
  String? description;
  Filters? filters;
  List<String>? nofollowCollections;

  GamesResponse(
      {this.count,
        this.next,
        this.previous,
        this.results,
        this.seoTitle,
        this.seoDescription,
        this.seoKeywords,
        this.seoH1,
        this.noindex,
        this.nofollow,
        this.description,
        this.filters,
        this.nofollowCollections});

  GamesResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Games>[];
      json['results'].forEach((v) {
        results!.add(new Games.fromJson(v));
      });
    }
    seoTitle = json['seo_title'];
    seoDescription = json['seo_description'];
    seoKeywords = json['seo_keywords'];
    seoH1 = json['seo_h1'];
    noindex = json['noindex'];
    nofollow = json['nofollow'];
    description = json['description'];
    filters =
    json['filters'] != null ? new Filters.fromJson(json['filters']) : null;
    nofollowCollections = json['nofollow_collections'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['seo_title'] = this.seoTitle;
    data['seo_description'] = this.seoDescription;
    data['seo_keywords'] = this.seoKeywords;
    data['seo_h1'] = this.seoH1;
    data['noindex'] = this.noindex;
    data['nofollow'] = this.nofollow;
    data['description'] = this.description;
    if (this.filters != null) {
      data['filters'] = this.filters!.toJson();
    }
    data['nofollow_collections'] = this.nofollowCollections;
    return data;
  }
}

class Filters {
  List<Years>? years;

  Filters({this.years});

  Filters.fromJson(Map<String, dynamic> json) {
    if (json['years'] != null) {
      years = <Years>[];
      json['years'].forEach((v) {
        years!.add(new Years.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.years != null) {
      data['years'] = this.years!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Years {
  int? from;
  int? to;
  String? filter;
  int? decade;
  List<Year>? years;
  bool? nofollow;
  int? count;

  Years(
      {this.from,
        this.to,
        this.filter,
        this.decade,
        this.years,
        this.nofollow,
        this.count});

  Years.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    filter = json['filter'];
    decade = json['decade'];
    if (json['years'] != null) {
      years = <Year>[];
      json['years'].forEach((v) {
        years!.add(new Year.fromJson(v));
      });
    }
    nofollow = json['nofollow'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    data['filter'] = this.filter;
    data['decade'] = this.decade;
    if (this.years != null) {
      data['years'] = this.years!.map((v) => v.toJson()).toList();
    }
    data['nofollow'] = this.nofollow;
    data['count'] = this.count;
    return data;
  }
}

class Year {
  int? year;
  int? count;
  bool? nofollow;

  Year({this.year, this.count, this.nofollow});

  Year.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    count = json['count'];
    nofollow = json['nofollow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['year'] = this.year;
    data['count'] = this.count;
    data['nofollow'] = this.nofollow;
    return data;
  }
}
