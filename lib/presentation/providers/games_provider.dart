

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rawg_app/data/providers/rawg_api.dart';
import 'package:rawg_app/data/repositories/rawg_repository_impl.dart';
import 'package:rawg_app/domain/models/games.dart';
import 'package:rawg_app/domain/repositories/rawg_repository.dart';
import 'package:rawg_app/domain/usecases/get_games.dart';


final rawgApiProvider = Provider<RawgApi>((ref) => RawgApi());
final rawgRepositoryProvider = Provider<RawgRepository>((ref) => RawgRepositoryImpl(ref.watch(rawgApiProvider)));
final getGamesProvider = Provider<GetGames>((ref) => GetGames(ref.watch(rawgRepositoryProvider)));
final getGamesByGenreProvider = Provider<GetGamesByGenre>((ref) => GetGamesByGenre(ref.watch(rawgRepositoryProvider)));
final searchGamesProvider = Provider<SearchGames>((ref) => SearchGames(ref.watch(rawgRepositoryProvider)));

final gamesProvider = FutureProvider.autoDispose.family<List<Games>, int>((ref, page) async {
  final getGames = ref.watch(getGamesProvider);
  return getGames(page);
});

final gamesByGenreProvider =
    FutureProvider.autoDispose.family<List<Games>, String>((ref, genre) async {
  final getGamesByGenre = ref.watch(getGamesByGenreProvider);
  return getGamesByGenre(genre, 1);
});

/// Searches games by [query]. Returns an empty list for blank queries so the
/// Explore page can render an idle state without hitting the network.
final gamesSearchProvider =
    FutureProvider.autoDispose.family<List<Games>, String>((ref, query) async {
  final trimmed = query.trim();
  if (trimmed.isEmpty) return <Games>[];
  return ref.watch(searchGamesProvider)(trimmed, 1);
});