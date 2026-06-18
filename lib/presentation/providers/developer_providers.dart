import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rawg_app/domain/models/developers.dart';
import 'package:rawg_app/domain/usecases/developer_usecases.dart';
import 'package:rawg_app/presentation/providers/games_provider.dart';

final getDevelopersProvider = Provider<GetDevelopers>(
    (ref) => GetDevelopers(ref.watch(rawgRepositoryProvider)));
final getDeveloperProvider = Provider<GetDeveloper>(
    (ref) => GetDeveloper(ref.watch(rawgRepositoryProvider)));

final developersProvider =
    FutureProvider.autoDispose.family<List<Developer>, int>((ref, page) async {
  return ref.watch(getDevelopersProvider)(page);
});

final developerProvider = FutureProvider.autoDispose
    .family<DeveloperSingle, String>((ref, id) async {
  return ref.watch(getDeveloperProvider)(id);
});
