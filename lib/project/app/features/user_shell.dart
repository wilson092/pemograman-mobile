import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pemob/project/app/widgets/app_bottom_nav.dart';
import 'package:pemob/project/app/widgets/app_drawer.dart';
import 'package:pemob/project/app/widgets/user_top_bar.dart';

class UserShell extends StatelessWidget {
  final Widget child;
  final String location;

  const UserShell({
    super.key,
    required this.child,
    required this.location,
  });

  int _calculateIndex() {
    if (location.startsWith('/map')) return 1;
    if (location.startsWith('/compare')) return 2;
    return 0;
  }

  String _screenTitle() {
    if (location.startsWith('/map')) return 'Peta';
    if (location.startsWith('/compare')) return 'Bandingkan';
    return 'Beranda';
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/map');
        break;
      case 2:
        context.go('/compare');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserTopBar(title: _screenTitle()),
      drawer: const AppDrawer(),
      body: child,
      bottomNavigationBar: AppBottomNav(
        type: BottomNavType.user,
        currentIndex: _calculateIndex(),
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
