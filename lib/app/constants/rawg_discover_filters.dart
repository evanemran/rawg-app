/// Preset `GET /games` filters for Discover drawer items.
class RawgDiscoverFilters {
  RawgDiscoverFilters._();

  static String _format(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Highest community rating first.
  static const topRatedOrdering = '-rating';

  /// Recently released within the last [days] days.
  static String newReleasesDates({int days = 30}) {
    final now = DateTime.now();
    final from = now.subtract(Duration(days: days));
    return '${_format(from)},${_format(now)}';
  }

  static const newReleasesOrdering = '-released';

  /// Games releasing from today through the next [days] days.
  static String upcomingDates({int days = 365}) {
    final now = DateTime.now();
    final to = now.add(Duration(days: days));
    return '${_format(now)},${_format(to)}';
  }

  static const upcomingOrdering = 'released';
}
