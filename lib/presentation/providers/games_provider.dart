

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rawg_app/data/providers/rawg_api.dart';
import 'package:rawg_app/data/repositories/rawg_repository_impl.dart';
import 'package:rawg_app/domain/models/games.dart';
import 'package:rawg_app/domain/repositories/rawg_repository.dart';
import 'package:rawg_app/domain/usecases/get_games.dart';


final rawgApiProvider = Provider<RawgApi>((ref) => RawgApi());
final rawgRepositoryProvider = Provider<RawgRepository>((ref) => RawgRepositoryImpl(ref.watch(rawgApiProvider)));
final getGamesProvider = Provider<GetGames>((ref) => GetGames(ref.watch(rawgRepositoryProvider)));

final gamesProvider = FutureProvider.autoDispose.family<List<Games>, int>((ref, page) async {
  final getGames = ref.watch(getGamesProvider);
  return getGames(page);
});