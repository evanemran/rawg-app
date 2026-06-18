import 'package:rawg_app/domain/models/genres.dart';
import 'package:rawg_app/domain/repositories/rawg_repository.dart';

class GetGenres {
  final RawgRepository repository;
  GetGenres(this.repository);

  Future<List<Genre>> call(int page) => repository.getGenres(page);
}

class GetGenre {
  final RawgRepository repository;
  GetGenre(this.repository);

  Future<GenreSingle> call(String id) => repository.getGenre(id);
}
