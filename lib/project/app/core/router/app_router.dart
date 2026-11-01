import 'package:go_router/go_router.dart';
import 'package:pemob/project/app/features/admin/activity_logs_screen.dart';
import 'package:pemob/project/app/features/admin/api_logs_screen.dart';
import 'package:pemob/project/app/features/admin/overview_screen.dart';
import 'package:pemob/project/app/features/admin/roles_screen.dart';
import 'package:pemob/project/app/features/admin/users_screen.dart';
import 'package:pemob/project/app/features/admin/weather_rules_screen.dart';
import 'package:pemob/project/app/features/admin_shell.dart';
import 'package:pemob/project/app/features/auth/login_screen.dart';
import 'package:pemob/project/app/features/compare/compare_screen.dart';
import 'package:pemob/project/app/features/home/home_screen.dart';
import 'package:pemob/project/app/features/map/map_screen.dart';
import 'package:pemob/project/app/features/user_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // User Shell
    ShellRoute(
      builder: (context, state, child) {
        return UserShell(
          location: state.uri.toString(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/map',
          builder: (context, state) => const MapScreen(),
        ),
        GoRoute(
          path: '/compare',
          builder: (context, state) => const CompareScreen(),
        ),
      ],
    ),
    // Admin Shell
    ShellRoute(
      builder: (context, state, child) {
        return AdminShell(
          location: state.uri.toString(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminOverviewScreen(),
        ),
        GoRoute(
          path: '/admin/alerts',
          builder: (context, state) => const WeatherRulesScreen(),
        ),
        GoRoute(
          path: '/admin/roles',
          builder: (context, state) => const RolesScreen(),
        ),
        GoRoute(
          path: '/admin/logs',
          builder: (context, state) => const ActivityLogsScreen(),
        ),
        GoRoute(
          path: '/admin/api-logs',
          builder: (context, state) => const ApiLogsScreen(),
        ),
        GoRoute(
          path: '/admin/users',
          builder: (context, state) => const UsersScreen(),
        ),
      ],
    ),
  ],
);
