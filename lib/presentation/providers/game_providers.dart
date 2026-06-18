import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rawg_app/domain/models/creators.dart';
import 'package:rawg_app/domain/models/game_media.dart';
import 'package:rawg_app/domain/models/game_single.dart';
import 'package:rawg_app/domain/models/games.dart';
import 'package:rawg_app/domain/models/stores.dart';
import 'package:rawg_app/domain/usecases/game_usecases.dart';
import 'package:rawg_app/presentation/providers/games_provider.dart';

final getGameAdditionsProvider = Provider<GetGameAdditions>(
    (ref) => GetGameAdditions(ref.watch(rawgRepositoryProvider)));
final getGameDevelopmentTeamProvider = Provider<GetGameDevelopmentTeam>(
    (ref) => GetGameDevelopmentTeam(ref.watch(rawgRepositoryProvider)));
final getGameSeriesProvider = Provider<GetGameSeries>(
    (ref) => GetGameSeries(ref.watch(rawgRepositoryProvider)));
final getParentGamesProvider = Provider<GetParentGames>(
    (ref) => GetParentGames(ref.watch(rawgRepositoryProvider)));
final getGameScreenshotsProvider = Provider<GetGameScreenshots>(
    (ref) => GetGameScreenshots(ref.watch(rawgRepositoryProvider)));
final getGameStoresProvider = Provider<GetGameStores>(
    (ref) => GetGameStores(ref.watch(rawgRepositoryProvider)));
final getGameDetailsProvider = Provider<GetGameDetails>(
    (ref) => GetGameDetails(ref.watch(rawgRepositoryProvider)));
final getGameAchievementsProvider = Provider<GetGameAchievements>(
    (ref) => GetGameAchievements(ref.watch(rawgRepositoryProvider)));
final getGameMoviesProvider = Provider<GetGameMovies>(
    (ref) => GetGameMovies(ref.watch(rawgRepositoryProvider)));
final getGameRedditProvider = Provider<GetGameReddit>(
    (ref) => GetGameReddit(ref.watch(rawgRepositoryProvider)));
final getSuggestedGamesProvider = Provider<GetSuggestedGames>(
    (ref) => GetSuggestedGames(ref.watch(rawgRepositoryProvider)));
final getGameTwitchProvider = Provider<GetGameTwitch>(
    (ref) => GetGameTwitch(ref.watch(rawgRepositoryProvider)));
final getGameYoutubeProvider = Provider<GetGameYoutube>(
    (ref) => GetGameYoutube(ref.watch(rawgRepositoryProvider)));

final gameAdditionsProvider = FutureProvider.autoDispose
    .family<List<Games>, ({String gamePk, int page})>((ref, args) async {
  return ref.watch(getGameAdditionsProvider)(args.gamePk, args.page);
});

final gameDevelopmentTeamProvider = FutureProvider.autoDispose
    .family<List<GamePersonList>, ({String gamePk, int page})>(
        (ref, args) async {
  return ref.watch(getGameDevelopmentTeamProvider)(args.gamePk, args.page);
});

final gameSeriesProvider = FutureProvider.autoDispose
    .family<List<Games>, ({String gamePk, int page})>((ref, args) async {
  return ref.watch(getGameSeriesProvider)(args.gamePk, args.page);
});

final parentGamesProvider = FutureProvider.autoDispose
    .family<List<Games>, ({String gamePk, int page})>((ref, args) async {
  return ref.watch(getParentGamesProvider)(args.gamePk, args.page);
});

final gameScreenshotsProvider = FutureProvider.autoDispose
    .family<List<ScreenShot>, ({String gamePk, int page})>((ref, args) async {
  return ref.watch(getGameScreenshotsProvider)(args.gamePk, args.page);
});

final gameStoresProvider = FutureProvider.autoDispose
    .family<List<GameStoreFull>, ({String gamePk, int page})>(
        (ref, args) async {
  return ref.watch(getGameStoresProvider)(args.gamePk, args.page);
});

final gameDetailsProvider =
    FutureProvider.autoDispose.family<GameSingle, String>((ref, id) async {
  return ref.watch(getGameDetailsProvider)(id);
});

final gameAchievementsProvider = FutureProvider.autoDispose
    .family<ParentAchievement, String>((ref, id) async {
  return ref.watch(getGameAchievementsProvider)(id);
});

final gameMoviesProvider =
    FutureProvider.autoDispose.family<Movie, String>((ref, id) async {
  return ref.watch(getGameMoviesProvider)(id);
});

final gameRedditProvider =
    FutureProvider.autoDispose.family<Reddit, String>((ref, id) async {
  return ref.watch(getGameRedditProvider)(id);
});

final suggestedGamesProvider =
    FutureProvider.autoDispose.family<GameSingle, String>((ref, id) async {
  return ref.watch(getSuggestedGamesProvider)(id);
});

final gameTwitchProvider =
    FutureProvider.autoDispose.family<Twitch, String>((ref, id) async {
  return ref.watch(getGameTwitchProvider)(id);
});

final gameYoutubeProvider =
    FutureProvider.autoDispose.family<Youtube, String>((ref, id) async {
  return ref.watch(getGameYoutubeProvider)(id);
});
