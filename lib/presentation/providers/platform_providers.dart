import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rawg_app/domain/models/platforms.dart';
import 'package:rawg_app/domain/usecases/platform_usecases.dart';
import 'package:rawg_app/presentation/providers/games_provider.dart';

final getPlatformsProvider = Provider<GetPlatforms>(
    (ref) => GetPlatforms(ref.watch(rawgRepositoryProvider)));
final getParentPlatformsProvider = Provider<GetParentPlatforms>(
    (ref) => GetParentPlatforms(ref.watch(rawgRepositoryProvider)));
final getPlatformProvider = Provider<GetPlatform>(
    (ref) => GetPlatform(ref.watch(rawgRepositoryProvider)));

final platformsProvider = FutureProvider.autoDispose
    .family<List<PlatformItem>, int>((ref, page) async {
  return ref.watch(getPlatformsProvider)(page);
});

final parentPlatformsProvider = FutureProvider.autoDispose
    .family<List<PlatformParentSingle>, int>((ref, page) async {
  return ref.watch(getParentPlatformsProvider)(page);
});

final platformProvider = FutureProvider.autoDispose
    .family<PlatformSingle, String>((ref, id) async {
  return ref.watch(getPlatformProvider)(id);
});
