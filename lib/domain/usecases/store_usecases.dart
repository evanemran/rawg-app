import 'package:rawg_app/domain/models/stores.dart';
import 'package:rawg_app/domain/repositories/rawg_repository.dart';

class GetStores {
  final RawgRepository repository;
  GetStores(this.repository);

  Future<List<StoreItem>> call(int page) => repository.getStores(page);
}

class GetStore {
  final RawgRepository repository;
  GetStore(this.repository);

  Future<StoreSingle> call(String id) => repository.getStore(id);
}
