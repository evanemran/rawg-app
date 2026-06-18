import 'package:flutter_riverpod/legacy.dart';

/// The top-level sections reachable from the zoom navigation drawer.
enum DrawerMenu {
  games('Games'),
  genres('Genres'),
  publishers('Publishers');

  const DrawerMenu(this.label);

  final String label;
}

/// Holds the currently selected drawer section. Defaults to [DrawerMenu.games].
final drawerMenuProvider = StateProvider<DrawerMenu>((ref) => DrawerMenu.games);
