import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rawg_app/domain/models/creators.dart';
import 'package:rawg_app/domain/usecases/creator_usecases.dart';
import 'package:rawg_app/presentation/providers/games_provider.dart';

final getCreatorRolesProvider = Provider<GetCreatorRoles>(
    (ref) => GetCreatorRoles(ref.watch(rawgRepositoryProvider)));
final getCreatorsProvider = Provider<GetCreators>(
    (ref) => GetCreators(ref.watch(rawgRepositoryProvider)));
final getCreatorProvider = Provider<GetCreator>(
    (ref) => GetCreator(ref.watch(rawgRepositoryProvider)));

final creatorRolesProvider =
    FutureProvider.autoDispose.family<List<Position>, int>((ref, page) async {
  return ref.watch(getCreatorRolesProvider)(page);
});

final creatorsProvider =
    FutureProvider.autoDispose.family<List<Person>, int>((ref, page) async {
  return ref.watch(getCreatorsProvider)(page);
});

final creatorProvider =
    FutureProvider.autoDispose.family<PersonSingle, String>((ref, id) async {
  return ref.watch(getCreatorProvider)(id);
});
