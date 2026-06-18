import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Holds the index of the currently selected tab in the [LandingPage]
/// bottom navigation bar.
final navigationIndexProvider = StateProvider<int>((ref) => 0);
