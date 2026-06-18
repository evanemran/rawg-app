import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rawg_app/domain/models/publishers.dart';
import 'package:rawg_app/domain/usecases/publisher_usecases.dart';
import 'package:rawg_app/presentation/providers/games_provider.dart';

final getPublishersProvider = Provider<GetPublishers>(
    (ref) => GetPublishers(ref.watch(rawgRepositoryProvider)));
final getPublisherProvider = Provider<GetPublisher>(
    (ref) => GetPublisher(ref.watch(rawgRepositoryProvider)));

final publishersProvider =
    FutureProvider.autoDispose.family<List<Publisher>, int>((ref, page) async {
  return ref.watch(getPublishersProvider)(page);
});

final publisherProvider = FutureProvider.autoDispose
    .family<PublisherSingle, String>((ref, id) async {
  return ref.watch(getPublisherProvider)(id);
});
