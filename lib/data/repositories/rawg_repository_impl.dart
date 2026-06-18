import 'package:rawg_app/data/providers/rawg_api.dart';
import 'package:rawg_app/domain/models/creators.dart';
import 'package:rawg_app/domain/models/developers.dart';
import 'package:rawg_app/domain/models/game_media.dart';
import 'package:rawg_app/domain/models/game_single.dart';
import 'package:rawg_app/domain/models/games.dart';
import 'package:rawg_app/domain/models/genres.dart';
import 'package:rawg_app/domain/models/paginated_response.dart';
import 'package:rawg_app/domain/models/platforms.dart';
import 'package:rawg_app/domain/models/publishers.dart';
import 'package:rawg_app/domain/models/stores.dart';
import 'package:rawg_app/domain/models/tags.dart';
import 'package:rawg_app/domain/repositories/rawg_repository.dart';

class RawgRepositoryImpl implements RawgRepository {
  final RawgApi api;

  RawgRepositoryImpl(this.api);

  // Creators
  @override
  Future<List<Position>> getCreatorRoles(int page) async {
    final raw = await api.fetchCreatorRoles(page);
    return PaginatedResponse.fromJson(raw, Position.fromJson).results;
  }

  @override
  Future<List<Person>> getCreators(int page) async {
    final raw = await api.fetchCreators(page);
    return PaginatedResponse.fromJson(raw, Person.fromJson).results;
  }

  @override
  Future<PersonSingle> getCreator(String id) async {
    final raw = await api.fetchCreator(id);
    return PersonSingle.fromJson(raw);
  }

  // Developers
  @override
  Future<List<Developer>> getDevelopers(int page) async {
    final raw = await api.fetchDevelopers(page);
    return PaginatedResponse.fromJson(raw, Developer.fromJson).results;
  }

  @override
  Future<DeveloperSingle> getDeveloper(String id) async {
    final raw = await api.fetchDeveloper(id);
    return DeveloperSingle.fromJson(raw);
  }

  // Games
  @override
  Future<List<Games>> getGames(int page) async {
    final raw = await api.fetchGames(page);
    return PaginatedResponse.fromJson(raw, Games.fromJson).results;
  }

  @override
  Future<List<Games>> searchGames(String query, int page) async {
    final raw = await api.searchGames(query, page);
    return PaginatedResponse.fromJson(raw, Games.fromJson).results;
  }

  @override
  Future<List<Games>> getGameAdditions(String gamePk, int page) async {
    final raw = await api.fetchGameAdditions(gamePk, page);
    return PaginatedResponse.fromJson(raw, Games.fromJson).results;
  }

  @override
  Future<List<GamePersonList>> getGameDevelopmentTeam(
      String gamePk, int page) async {
    final raw = await api.fetchGameDevelopmentTeam(gamePk, page);
    return PaginatedResponse.fromJson(raw, GamePersonList.fromJson).results;
  }

  @override
  Future<List<Games>> getGameSeries(String gamePk, int page) async {
    final raw = await api.fetchGameSeries(gamePk, page);
    return PaginatedResponse.fromJson(raw, Games.fromJson).results;
  }

  @override
  Future<List<Games>> getParentGames(String gamePk, int page) async {
    final raw = await api.fetchParentGames(gamePk, page);
    return PaginatedResponse.fromJson(raw, Games.fromJson).results;
  }

  @override
  Future<List<ScreenShot>> getGameScreenshots(String gamePk, int page) async {
    final raw = await api.fetchGameScreenshots(gamePk, page);
    return PaginatedResponse.fromJson(raw, ScreenShot.fromJson).results;
  }

  @override
  Future<List<GameStoreFull>> getGameStores(String gamePk, int page) async {
    final raw = await api.fetchGameStores(gamePk, page);
    return PaginatedResponse.fromJson(raw, GameStoreFull.fromJson).results;
  }

  @override
  Future<GameSingle> getGameDetails(String id) async {
    final raw = await api.fetchGameDetails(id);
    return GameSingle.fromJson(raw);
  }

  @override
  Future<ParentAchievement> getGameAchievements(String id) async {
    final raw = await api.fetchGameAchievements(id);
    return ParentAchievement.fromJson(raw);
  }

  @override
  Future<Movie> getGameMovies(String id) async {
    final raw = await api.fetchGameMovies(id);
    return Movie.fromJson(raw);
  }

  @override
  Future<Reddit> getGameReddit(String id) async {
    final raw = await api.fetchGameReddit(id);
    return Reddit.fromJson(raw);
  }

  @override
  Future<GameSingle> getSuggestedGames(String id) async {
    final raw = await api.fetchSuggestedGames(id);
    return GameSingle.fromJson(raw);
  }

  @override
  Future<Twitch> getGameTwitch(String id) async {
    final raw = await api.fetchGameTwitch(id);
    return Twitch.fromJson(raw);
  }

  @override
  Future<Youtube> getGameYoutube(String id) async {
    final raw = await api.fetchGameYoutube(id);
    return Youtube.fromJson(raw);
  }

  // Genres
  @override
  Future<List<Genre>> getGenres(int page) async {
    final raw = await api.fetchGenres(page);
    return PaginatedResponse.fromJson(raw, Genre.fromJson).results;
  }

  @override
  Future<GenreSingle> getGenre(String id) async {
    final raw = await api.fetchGenre(id);
    return GenreSingle.fromJson(raw);
  }

  // Platforms
  @override
  Future<List<PlatformItem>> getPlatforms(int page) async {
    final raw = await api.fetchPlatforms(page);
    return PaginatedResponse.fromJson(raw, PlatformItem.fromJson).results;
  }

  @override
  Future<List<PlatformParentSingle>> getParentPlatforms(int page) async {
    final raw = await api.fetchParentPlatforms(page);
    return PaginatedResponse.fromJson(raw, PlatformParentSingle.fromJson)
        .results;
  }

  @override
  Future<PlatformSingle> getPlatform(String id) async {
    final raw = await api.fetchPlatform(id);
    return PlatformSingle.fromJson(raw);
  }

  // Publishers
  @override
  Future<List<Publisher>> getPublishers(int page) async {
    final raw = await api.fetchPublishers(page);
    return PaginatedResponse.fromJson(raw, Publisher.fromJson).results;
  }

  @override
  Future<PublisherSingle> getPublisher(String id) async {
    final raw = await api.fetchPublisher(id);
    return PublisherSingle.fromJson(raw);
  }

  // Stores
  @override
  Future<List<StoreItem>> getStores(int page) async {
    final raw = await api.fetchStores(page);
    return PaginatedResponse.fromJson(raw, StoreItem.fromJson).results;
  }

  @override
  Future<StoreSingle> getStore(String id) async {
    final raw = await api.fetchStore(id);
    return StoreSingle.fromJson(raw);
  }

  // Tags
  @override
  Future<List<Tag>> getTags(int page) async {
    final raw = await api.fetchTags(page);
    return PaginatedResponse.fromJson(raw, Tag.fromJson).results;
  }

  @override
  Future<TagSingle> getTag(String id) async {
    final raw = await api.fetchTag(id);
    return TagSingle.fromJson(raw);
  }
}
