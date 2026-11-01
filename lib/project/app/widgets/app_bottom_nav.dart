import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';

enum BottomNavType { user, admin }

class AppBottomNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const AppBottomNavItem({
    required this.label,
    required this.icon,
    IconData? activeIcon,
  }) : activeIcon = activeIcon ?? icon;
}

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final BottomNavType type;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.type = BottomNavType.user,
  });

  static const List<AppBottomNavItem> userItems = [
    AppBottomNavItem(
      label: 'Beranda',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    AppBottomNavItem(
      label: 'Peta',
      icon: Icons.map_outlined,
      activeIcon: Icons.map,
    ),
    AppBottomNavItem(
      label: 'Bandingkan',
      icon: Icons.compare_arrows_outlined,
      activeIcon: Icons.compare_arrows,
    ),
  ];

  static const List<AppBottomNavItem> adminItems = [
    AppBottomNavItem(
      label: 'Overview',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
    ),
    AppBottomNavItem(
      label: 'Alerts',
      icon: Icons.notifications_none,
      activeIcon: Icons.notifications,
    ),
    AppBottomNavItem(
      label: 'Role',
      icon: Icons.admin_panel_settings_outlined,
      activeIcon: Icons.admin_panel_settings,
    ),
    AppBottomNavItem(
      label: 'Logs',
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final items = type == BottomNavType.user ? userItems : adminItems;

    return Container(
      height: AppDimensions.bottomNavHeight,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.border, width: AppDimensions.borderWidth),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == currentIndex;
          final color = isSelected ? AppColors.primary : AppColors.textSecondary;

          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected ? item.activeIcon : item.icon,
                    color: color,
                    size: 22,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.label,
                    style: AppTextStyles.caption.copyWith(
                      color: color,
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
