import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rawg_app/domain/models/genres.dart';
import 'package:rawg_app/domain/usecases/genre_usecases.dart';
import 'package:rawg_app/presentation/providers/games_provider.dart';

final getGenresProvider =
    Provider<GetGenres>((ref) => GetGenres(ref.watch(rawgRepositoryProvider)));
final getGenreProvider =
    Provider<GetGenre>((ref) => GetGenre(ref.watch(rawgRepositoryProvider)));

final genresProvider =
    FutureProvider.autoDispose.family<List<Genre>, int>((ref, page) async {
  return ref.watch(getGenresProvider)(page);
});

final genreProvider =
    FutureProvider.autoDispose.family<GenreSingle, String>((ref, id) async {
  return ref.watch(getGenreProvider)(id);
});
