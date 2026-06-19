import 'dart:convert';

import '../../app/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class RawgApi {
  /// Builds a request [Uri] for [path], always injecting the API key and
  /// merging in any extra [query] parameters (null values are skipped).
  Uri _buildUri(String path, [Map<String, dynamic>? query]) {
    final params = <String, String>{'key': ApiConstants.apiKey};
    if (query != null) {
      query.forEach((key, value) {
        if (value != null) params[key] = value.toString();
      });
    }
    return Uri.parse('${ApiConstants.baseUrl}$path')
        .replace(queryParameters: params);
  }

  /// Performs a GET request and returns the decoded JSON body.
  Future<Map<String, dynamic>> _get(
    String path, [
    Map<String, dynamic>? query,
  ]) async {
    final headers = {'Content-Type': 'application/json'};
    try {
      final response = await http.get(_buildUri(path, query), headers: headers);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch $path: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Creators
  // ---------------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchCreatorRoles(int page, {int? pageSize}) {
    return _get(ApiConstants.creatorRoles, {'page': page, 'page_size': pageSize});
  }

  Future<Map<String, dynamic>> fetchCreators(int page, {int? pageSize}) {
    return _get(ApiConstants.creators, {'page': page, 'page_size': pageSize});
  }

  Future<Map<String, dynamic>> fetchCreator(String id) {
    return _get('${ApiConstants.creators}/$id');
  }

  // ---------------------------------------------------------------------------
  // Developers
  // ---------------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchDevelopers(int page, {int? pageSize}) {
    return _get(ApiConstants.developers, {'page': page, 'page_size': pageSize});
  }

  Future<Map<String, dynamic>> fetchDeveloper(String id) {
    return _get('${ApiConstants.developers}/$id');
  }

  // ---------------------------------------------------------------------------
  // Games
  // ---------------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchGames(int page, {int? pageSize}) {
    return _get(ApiConstants.games, {'page': page, 'page_size': pageSize});
  }

  Future<Map<String, dynamic>> fetchGamesByGenre(
    String genre,
    int page, {
    int? pageSize,
  }) {
    return _get(ApiConstants.games, {
      'genres': genre,
      'page': page,
      'page_size': pageSize,
    });
  }

  Future<Map<String, dynamic>> searchGames(
    String query,
    int page, {
    int? pageSize,
  }) {
    return _get(ApiConstants.games, {
      'search': query,
      'page': page,
      'page_size': pageSize,
    });
  }

  Future<Map<String, dynamic>> fetchGameAdditions(String gamePk, int page) {
    return _get('${ApiConstants.games}/$gamePk/additions', {'page': page});
  }

  Future<Map<String, dynamic>> fetchGameDevelopmentTeam(
    String gamePk,
    int page, {
    String? ordering,
  }) {
    return _get('${ApiConstants.games}/$gamePk/development-team', {
      'page': page,
      'ordering': ordering,
    });
  }

  Future<Map<String, dynamic>> fetchGameSeries(String gamePk, int page) {
    return _get('${ApiConstants.games}/$gamePk/game-series', {'page': page});
  }

  Future<Map<String, dynamic>> fetchParentGames(String gamePk, int page) {
    return _get('${ApiConstants.games}/$gamePk/parent-games', {'page': page});
  }

  Future<Map<String, dynamic>> fetchGameScreenshots(
    String gamePk,
    int page, {
    String? ordering,
  }) {
    return _get('${ApiConstants.games}/$gamePk/screenshots', {
      'page': page,
      'ordering': ordering,
    });
  }

  Future<Map<String, dynamic>> fetchGameStores(
    String gamePk,
    int page, {
    String? ordering,
  }) {
    return _get('${ApiConstants.games}/$gamePk/stores', {
      'page': page,
      'ordering': ordering,
    });
  }

  Future<Map<String, dynamic>> fetchGameDetails(String id) {
    return _get('${ApiConstants.games}/$id');
  }

  Future<Map<String, dynamic>> fetchGameAchievements(String id) {
    return _get('${ApiConstants.games}/$id/achievements');
  }

  Future<Map<String, dynamic>> fetchGameMovies(String id) {
    return _get('${ApiConstants.games}/$id/movies');
  }

  Future<Map<String, dynamic>> fetchGameReddit(String id) {
    return _get('${ApiConstants.games}/$id/reddit');
  }

  Future<Map<String, dynamic>> fetchSuggestedGames(String id) {
    return _get('${ApiConstants.games}/$id/suggested');
  }

  Future<Map<String, dynamic>> fetchGameTwitch(String id) {
    return _get('${ApiConstants.games}/$id/twitch');
  }

  Future<Map<String, dynamic>> fetchGameYoutube(String id) {
    return _get('${ApiConstants.games}/$id/youtube');
  }

  // ---------------------------------------------------------------------------
  // Genres
  // ---------------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchGenres(int page,
      {int? pageSize, String? ordering}) {
    return _get(ApiConstants.genres, {
      'page': page,
      'page_size': pageSize,
      'ordering': ordering,
    });
  }

  Future<Map<String, dynamic>> fetchGenre(String id) {
    return _get('${ApiConstants.genres}/$id');
  }

  // ---------------------------------------------------------------------------
  // Platforms
  // ---------------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchPlatforms(int page,
      {int? pageSize, String? ordering}) {
    return _get(ApiConstants.platforms, {
      'page': page,
      'page_size': pageSize,
      'ordering': ordering,
    });
  }

  Future<Map<String, dynamic>> fetchParentPlatforms(int page,
      {int? pageSize, String? ordering}) {
    return _get(ApiConstants.parentPlatforms, {
      'page': page,
      'page_size': pageSize,
      'ordering': ordering,
    });
  }

  Future<Map<String, dynamic>> fetchPlatform(String id) {
    return _get('${ApiConstants.platforms}/$id');
  }

  // ---------------------------------------------------------------------------
  // Publishers
  // ---------------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchPublishers(int page, {int? pageSize}) {
    return _get(ApiConstants.publishers, {'page': page, 'page_size': pageSize});
  }

  Future<Map<String, dynamic>> fetchPublisher(String id) {
    return _get('${ApiConstants.publishers}/$id');
  }

  // ---------------------------------------------------------------------------
  // Stores
  // ---------------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchStores(int page,
      {int? pageSize, String? ordering}) {
    return _get(ApiConstants.stores, {
      'page': page,
      'page_size': pageSize,
      'ordering': ordering,
    });
  }

  Future<Map<String, dynamic>> fetchStore(String id) {
    return _get('${ApiConstants.stores}/$id');
  }

  // ---------------------------------------------------------------------------
  // Tags
  // ---------------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchTags(int page, {int? pageSize}) {
    return _get(ApiConstants.tags, {'page': page, 'page_size': pageSize});
  }

  Future<Map<String, dynamic>> fetchTag(String id) {
    return _get('${ApiConstants.tags}/$id');
  }
}
