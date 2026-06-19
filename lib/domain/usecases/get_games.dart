import 'package:rawg_app/domain/models/games.dart';
import 'package:rawg_app/domain/repositories/rawg_repository.dart';

class GetGames {

  final RawgRepository repository;

  GetGames(this.repository);

  Future<List<Games>> call(int page) => repository.getGames(page);
}

class GetGamesByGenre {
  final RawgRepository repository;

  GetGamesByGenre(this.repository);

  Future<List<Games>> call(String genre, int page) =>
      repository.getGamesByGenre(genre, page);
}

class SearchGames {
  final RawgRepository repository;

  SearchGames(this.repository);

  Future<List<Games>> call(String query, int page) =>
      repository.searchGames(query, page);
}