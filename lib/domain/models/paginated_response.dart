/// Generic wrapper for RAWG list endpoints which all share the
/// `{count, next, previous, results}` shape.
class PaginatedResponse<T> {
  int? count;
  String? next;
  String? previous;
  List<T> results;

  PaginatedResponse({
    this.count,
    this.next,
    this.previous,
    this.results = const [],
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList() ??
          <T>[],
    );
  }
}
