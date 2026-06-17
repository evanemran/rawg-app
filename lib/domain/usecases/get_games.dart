import 'package:rawg_app/domain/models/games.dart';
import 'package:rawg_app/domain/repositories/rawg_repository.dart';

class GetGames {

  final RawgRepository repository;

  GetGames(this.repository);

  Future<List<Games>> call(int page) => repository.getGames(page);
}