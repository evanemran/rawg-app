import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rawg_app/domain/models/stores.dart';
import 'package:rawg_app/domain/usecases/store_usecases.dart';
import 'package:rawg_app/presentation/providers/games_provider.dart';

final getStoresProvider =
    Provider<GetStores>((ref) => GetStores(ref.watch(rawgRepositoryProvider)));
final getStoreProvider =
    Provider<GetStore>((ref) => GetStore(ref.watch(rawgRepositoryProvider)));

final storesProvider =
    FutureProvider.autoDispose.family<List<StoreItem>, int>((ref, page) async {
  return ref.watch(getStoresProvider)(page);
});

final storeProvider =
    FutureProvider.autoDispose.family<StoreSingle, String>((ref, id) async {
  return ref.watch(getStoreProvider)(id);
});
