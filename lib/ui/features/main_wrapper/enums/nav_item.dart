import 'package:flutter/material.dart';
import '../../../../core/services/router/app_router.dart';
import '../../../../utils/extension_functions.dart';

/// NavItem Enum for bottom navigation bar
/// 
enum NavItem {
  home(
    path: AppRouter.home,
    label: "Home",
    icon: Icons.home,
    activeIcon: Icons.home,
  ),
  profile(
    path: AppRouter.profile,
    label: "Profile",
    icon: Icons.person,
    activeIcon: Icons.person,
  );

  const NavItem({
    required this.path,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String path;
  final String label;
  final IconData icon;
  final IconData activeIcon;

  /// Method to get the localized label
  /// [context] context of the widget
  /// [forAppBar] is localized label is to shown on app bar
  ///
  String localizedLabel(
    BuildContext context, {
    bool forAppBar = false,
  }) {
    return this == home
        ? context.appLocalization.tab_home
            : context.appLocalization.tab_profile;
  }
}
