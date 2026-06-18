import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rawg_app/domain/models/tags.dart';
import 'package:rawg_app/domain/usecases/tag_usecases.dart';
import 'package:rawg_app/presentation/providers/games_provider.dart';

final getTagsProvider =
    Provider<GetTags>((ref) => GetTags(ref.watch(rawgRepositoryProvider)));
final getTagProvider =
    Provider<GetTag>((ref) => GetTag(ref.watch(rawgRepositoryProvider)));

final tagsProvider =
    FutureProvider.autoDispose.family<List<Tag>, int>((ref, page) async {
  return ref.watch(getTagsProvider)(page);
});

final tagProvider =
    FutureProvider.autoDispose.family<TagSingle, String>((ref, id) async {
  return ref.watch(getTagProvider)(id);
});
