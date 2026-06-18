import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../app/theme/app_colors.dart';
import '../providers/drawer_provider.dart';
import 'drawer_menu_screen.dart';
import 'genres_menu_page.dart';
import 'landing_page.dart';
import 'publishers_menu_page.dart';

/// Root of the app: hosts the zoom navigation drawer. The selected drawer
/// section ([drawerMenuProvider]) decides which main screen is shown, and
/// switching sections simply replaces the main screen (no navigation stack).
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ZoomDrawer(
      style: DrawerStyle.defaultStyle,
      borderRadius: 24,
      showShadow: true,
      angle: 0,
      menuBackgroundColor: AppColors.surface,
      shadowLayer1Color: AppColors.drawerShadowOne,
      shadowLayer2Color: AppColors.drawerShadowTwo,
      drawerShadowsBackgroundColor: AppColors.surfaceVariant,
      mainScreenScale: 0.2,
      slideWidth: MediaQuery.of(context).size.width * 0.7,
      openCurve: Curves.easeOutCubic,
      closeCurve: Curves.easeOutCubic,
      menuScreenTapClose: true,
      mainScreenTapClose: true,
      menuScreen: const DrawerMenuScreen(),
      mainScreen: const _MainScreen(),
    );
  }
}

class _MainScreen extends ConsumerWidget {
  const _MainScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menu = ref.watch(drawerMenuProvider);
    switch (menu) {
      case DrawerMenu.games:
        return const LandingPage();
      case DrawerMenu.genres:
        return const GenresMenuPage();
      case DrawerMenu.publishers:
        return const PublishersMenuPage();
    }
  }
}
