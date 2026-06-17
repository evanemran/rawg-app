import 'package:rawg_app/domain/models/games.dart';

abstract class RawgRepository {
  Future<List<Games>> getGames(int page);
}