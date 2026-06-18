import 'package:rawg_app/domain/models/creators.dart';
import 'package:rawg_app/domain/models/game_media.dart';
import 'package:rawg_app/domain/models/game_single.dart';
import 'package:rawg_app/domain/models/games.dart';
import 'package:rawg_app/domain/models/stores.dart';
import 'package:rawg_app/domain/repositories/rawg_repository.dart';

class GetGameAdditions {
  final RawgRepository repository;
  GetGameAdditions(this.repository);

  Future<List<Games>> call(String gamePk, int page) =>
      repository.getGameAdditions(gamePk, page);
}

class GetGameDevelopmentTeam {
  final RawgRepository repository;
  GetGameDevelopmentTeam(this.repository);

  Future<List<GamePersonList>> call(String gamePk, int page) =>
      repository.getGameDevelopmentTeam(gamePk, page);
}

class GetGameSeries {
  final RawgRepository repository;
  GetGameSeries(this.repository);

  Future<List<Games>> call(String gamePk, int page) =>
      repository.getGameSeries(gamePk, page);
}

class GetParentGames {
  final RawgRepository repository;
  GetParentGames(this.repository);

  Future<List<Games>> call(String gamePk, int page) =>
      repository.getParentGames(gamePk, page);
}

class GetGameScreenshots {
  final RawgRepository repository;
  GetGameScreenshots(this.repository);

  Future<List<ScreenShot>> call(String gamePk, int page) =>
      repository.getGameScreenshots(gamePk, page);
}

class GetGameStores {
  final RawgRepository repository;
  GetGameStores(this.repository);

  Future<List<GameStoreFull>> call(String gamePk, int page) =>
      repository.getGameStores(gamePk, page);
}

class GetGameDetails {
  final RawgRepository repository;
  GetGameDetails(this.repository);

  Future<GameSingle> call(String id) => repository.getGameDetails(id);
}

class GetGameAchievements {
  final RawgRepository repository;
  GetGameAchievements(this.repository);

  Future<ParentAchievement> call(String id) =>
      repository.getGameAchievements(id);
}

class GetGameMovies {
  final RawgRepository repository;
  GetGameMovies(this.repository);

  Future<Movie> call(String id) => repository.getGameMovies(id);
}

class GetGameReddit {
  final RawgRepository repository;
  GetGameReddit(this.repository);

  Future<Reddit> call(String id) => repository.getGameReddit(id);
}

class GetSuggestedGames {
  final RawgRepository repository;
  GetSuggestedGames(this.repository);

  Future<GameSingle> call(String id) => repository.getSuggestedGames(id);
}

class GetGameTwitch {
  final RawgRepository repository;
  GetGameTwitch(this.repository);

  Future<Twitch> call(String id) => repository.getGameTwitch(id);
}

class GetGameYoutube {
  final RawgRepository repository;
  GetGameYoutube(this.repository);

  Future<Youtube> call(String id) => repository.getGameYoutube(id);
}
