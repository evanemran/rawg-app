import 'package:rawg_app/domain/models/publishers.dart';
import 'package:rawg_app/domain/repositories/rawg_repository.dart';

class GetPublishers {
  final RawgRepository repository;
  GetPublishers(this.repository);

  Future<List<Publisher>> call(int page) => repository.getPublishers(page);
}

class GetPublisher {
  final RawgRepository repository;
  GetPublisher(this.repository);

  Future<PublisherSingle> call(String id) => repository.getPublisher(id);
}
