import 'package:rawg_app/domain/models/tags.dart';
import 'package:rawg_app/domain/repositories/rawg_repository.dart';

class GetTags {
  final RawgRepository repository;
  GetTags(this.repository);

  Future<List<Tag>> call(int page) => repository.getTags(page);
}

class GetTag {
  final RawgRepository repository;
  GetTag(this.repository);

  Future<TagSingle> call(String id) => repository.getTag(id);
}
