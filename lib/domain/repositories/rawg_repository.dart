import 'package:rawg_app/domain/models/creators.dart';
import 'package:rawg_app/domain/models/developers.dart';
import 'package:rawg_app/domain/models/game_media.dart';
import 'package:rawg_app/domain/models/game_single.dart';
import 'package:rawg_app/domain/models/games.dart';
import 'package:rawg_app/domain/models/genres.dart';
import 'package:rawg_app/domain/models/platforms.dart';
import 'package:rawg_app/domain/models/publishers.dart';
import 'package:rawg_app/domain/models/stores.dart';
import 'package:rawg_app/domain/models/tags.dart';

abstract class RawgRepository {
  // Creators
  Future<List<Position>> getCreatorRoles(int page);
  Future<List<Person>> getCreators(int page);
  Future<PersonSingle> getCreator(String id);

  // Developers
  Future<List<Developer>> getDevelopers(int page);
  Future<DeveloperSingle> getDeveloper(String id);

  // Games
  Future<List<Games>> getGames(int page);
  Future<List<Games>> getGameAdditions(String gamePk, int page);
  Future<List<GamePersonList>> getGameDevelopmentTeam(String gamePk, int page);
  Future<List<Games>> getGameSeries(String gamePk, int page);
  Future<List<Games>> getParentGames(String gamePk, int page);
  Future<List<ScreenShot>> getGameScreenshots(String gamePk, int page);
  Future<List<GameStoreFull>> getGameStores(String gamePk, int page);
  Future<GameSingle> getGameDetails(String id);
  Future<ParentAchievement> getGameAchievements(String id);
  Future<Movie> getGameMovies(String id);
  Future<Reddit> getGameReddit(String id);
  Future<GameSingle> getSuggestedGames(String id);
  Future<Twitch> getGameTwitch(String id);
  Future<Youtube> getGameYoutube(String id);

  // Genres
  Future<List<Genre>> getGenres(int page);
  Future<GenreSingle> getGenre(String id);

  // Platforms
  Future<List<PlatformItem>> getPlatforms(int page);
  Future<List<PlatformParentSingle>> getParentPlatforms(int page);
  Future<PlatformSingle> getPlatform(String id);

  // Publishers
  Future<List<Publisher>> getPublishers(int page);
  Future<PublisherSingle> getPublisher(String id);

  // Stores
  Future<List<StoreItem>> getStores(int page);
  Future<StoreSingle> getStore(String id);

  // Tags
  Future<List<Tag>> getTags(int page);
  Future<TagSingle> getTag(String id);
}
