class CollectionException implements Exception {
  final String message;

  const CollectionException(this.message);

  @override
  String toString() => message;
}
