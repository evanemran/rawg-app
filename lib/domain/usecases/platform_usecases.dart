import 'package:rawg_app/domain/models/platforms.dart';
import 'package:rawg_app/domain/repositories/rawg_repository.dart';

class GetPlatforms {
  final RawgRepository repository;
  GetPlatforms(this.repository);

  Future<List<PlatformItem>> call(int page) => repository.getPlatforms(page);
}

class GetParentPlatforms {
  final RawgRepository repository;
  GetParentPlatforms(this.repository);

  Future<List<PlatformParentSingle>> call(int page) =>
      repository.getParentPlatforms(page);
}

class GetPlatform {
  final RawgRepository repository;
  GetPlatform(this.repository);

  Future<PlatformSingle> call(String id) => repository.getPlatform(id);
}
