import 'package:rawg_app/domain/models/creators.dart';
import 'package:rawg_app/domain/repositories/rawg_repository.dart';

class GetCreatorRoles {
  final RawgRepository repository;
  GetCreatorRoles(this.repository);

  Future<List<Position>> call(int page) => repository.getCreatorRoles(page);
}

class GetCreators {
  final RawgRepository repository;
  GetCreators(this.repository);

  Future<List<Person>> call(int page) => repository.getCreators(page);
}

class GetCreator {
  final RawgRepository repository;
  GetCreator(this.repository);

  Future<PersonSingle> call(String id) => repository.getCreator(id);
}
