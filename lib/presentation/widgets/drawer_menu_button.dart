import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:rawg_app/app/theme/app_images.dart';

import '../../app/theme/app_colors.dart';

/// A hamburger button that toggles the surrounding [ZoomDrawer].
///
/// Works from any widget rendered inside the drawer's main screen.
class DrawerMenuButton extends StatelessWidget {
  const DrawerMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => ZoomDrawer.of(context)?.toggle(),
      icon: Image.asset(AppImages.drawerIcon, color: AppColors.textPrimary, height: 24,),
      tooltip: 'Menu',
    );
  }
}
