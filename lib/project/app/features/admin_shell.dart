import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pemob/project/app/widgets/app_bottom_nav.dart';
import 'package:pemob/project/app/widgets/app_drawer.dart';

class AdminShell extends StatelessWidget {
  final Widget child;
  final String location;

  const AdminShell({
    super.key,
    required this.child,
    required this.location,
  });

  int _calculateIndex() {
    if (location.startsWith('/admin/alerts')) return 1;
    if (location.startsWith('/admin/roles') || location.startsWith('/admin/users')) return 2;
    if (location.startsWith('/admin/logs') || location.startsWith('/admin/api-logs')) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/admin');
        break;
      case 1:
        context.go('/admin/alerts');
        break;
      case 2:
        context.go('/admin/roles');
        break;
      case 3:
        context.go('/admin/logs');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: child,
      bottomNavigationBar: AppBottomNav(
        type: BottomNavType.admin,
        currentIndex: _calculateIndex(),
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
