import 'package:flutter/material.dart';

import 'game_list_page.dart';

/// Pushes [GameListPage] showing a paginated list of games.
void openGameList(
  BuildContext context, {
  required String title,
  String? genre,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => GameListPage(title: title, genre: genre),
    ),
  );
}
