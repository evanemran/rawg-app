import 'package:rawg_app/domain/models/developers.dart';
import 'package:rawg_app/domain/repositories/rawg_repository.dart';

class GetDevelopers {
  final RawgRepository repository;
  GetDevelopers(this.repository);

  Future<List<Developer>> call(int page) => repository.getDevelopers(page);
}

class GetDeveloper {
  final RawgRepository repository;
  GetDeveloper(this.repository);

  Future<DeveloperSingle> call(String id) => repository.getDeveloper(id);
}
