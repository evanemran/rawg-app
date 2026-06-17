import 'package:rawg_app/data/providers/rawg_api.dart';
import 'package:rawg_app/domain/models/games.dart';
import 'package:rawg_app/domain/models/games_response.dart';
import 'package:rawg_app/domain/repositories/rawg_repository.dart';

class RawgRepositoryImpl implements RawgRepository{
  final RawgApi api;


  RawgRepositoryImpl(this.api);

  @override
  Future<List<Games>> getGames(int page) async {
    final rawList = await api.fetchGames(page);
    final response = GamesResponse.fromJson(rawList);
    return response.results ?? [];
  }

}