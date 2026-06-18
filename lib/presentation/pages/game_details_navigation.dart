import 'package:flutter/material.dart';

import '../../domain/models/games.dart';
import 'game_details_page.dart';

/// Pushes the [GameDetailsPage] for the given [game].
void openGameDetails(BuildContext context, Games game) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => GameDetailsPage(game: game)),
  );
}
