import 'package:pemob/project/app/data/models/activity_log.dart';
import 'package:pemob/project/app/data/models/api_log.dart';
import 'package:pemob/project/app/data/models/app_user.dart';
import 'package:pemob/project/app/data/models/role.dart';
import 'package:pemob/project/app/data/repositories/admin_repository.dart';

class MockAdminRepository implements AdminRepository {
  static const List<AppUser> seedUsers = [
    AppUser(
      id: 1,
      name: 'Andi Pratama',
      email: 'andi@gmail.com',
      role: UserRole.user,
      isActive: true,
    ),
    AppUser(
      id: 2,
      name: 'Siti Rahma',
      email: 'siti.r@gmail.com',
      role: UserRole.user,
      isActive: true,
    ),
    AppUser(
      id: 3,
      name: 'Admin Utama',
      email: 'admin@weatherinsight.id',
      role: UserRole.admin,
      isActive: true,
    ),
    AppUser(
      id: 4,
      name: 'Budi Santoso',
      email: 'budi@gmail.com',
      role: UserRole.user,
      isActive: false,
    ),
    AppUser(
      id: 5,
      name: 'Dewi Lestari',
      email: 'dewi.l@gmail.com',
      role: UserRole.user,
      isActive: true,
    ),
    AppUser(
      id: 6,
      name: 'Rizky Maulana',
      email: 'rizky.m@gmail.com',
      role: UserRole.admin,
      isActive: true,
    ),
  ];

  static const List<Role> seedRoles = [
    Role(
      id: 1,
      name: 'Admin',
      badge: 'Super',
      userCount: 2,
      description: 'Akses dashboard admin',
      permissionLabel: 'Akses Penuh',
    ),
    Role(
      id: 2,
      name: 'User',
      badge: 'Aktif',
      userCount: 146,
      description: 'Akses fitur cuaca',
      permissionLabel: 'Baca Saja',
    ),
  ];

  static const List<ActivityLog> seedActivityLogs = [
    ActivityLog(
      id: '1',
      actionCode: 'LOGIN_SUCCESS',
      badgeText: 'Berhasil',
      badgeStyle: ActivityBadgeStyle.success,
      message: 'Login berhasil melalui Google',
      userId: 'user #12',
      ipAddress: '10.0.0.5',
      time: '09:52',
      category: ActivityCategory.autentikasi,
    ),
    ActivityLog(
      id: '2',
      actionCode: 'FAVORITE_ADD',
      badgeText: 'Pref',
      badgeStyle: ActivityBadgeStyle.neutral,
      message: 'Menambahkan favorit: Bandung, ID',
      userId: 'user #12',
      ipAddress: '10.0.0.5',
      time: '09:53',
      category: ActivityCategory.favorit,
    ),
    ActivityLog(
      id: '3',
      actionCode: 'LOGIN_FAILED',
      badgeText: 'Auth Gagal',
      badgeStyle: ActivityBadgeStyle.error,
      message: 'Login gagal melalui email: password salah',
      userId: null,
      ipAddress: '10.0.0.9',
      time: '09:40',
      category: ActivityCategory.autentikasi,
    ),
    ActivityLog(
      id: '4',
      actionCode: 'WEATHER_RULE_UPDATE',
      badgeText: 'Config',
      badgeStyle: ActivityBadgeStyle.neutral,
      message: 'Mengubah aturan Sedang: 22,0-35,0 -> 21,0-35,0',
      userId: 'user #1',
      ipAddress: '10.0.0.2',
      time: '09:31',
      category: ActivityCategory.admin,
    ),
    ActivityLog(
      id: '5',
      actionCode: 'USER_ROLE_CHANGE',
      badgeText: 'Role',
      badgeStyle: ActivityBadgeStyle.neutral,
      message: 'Mengubah peran pengguna #12: User -> Admin',
      userId: 'user #1',
      ipAddress: '10.0.0.2',
      time: '09:20',
      category: ActivityCategory.admin,
    ),
    ActivityLog(
      id: '6',
      actionCode: 'ACCESS_DENIED',
      badgeText: 'Security 403',
      badgeStyle: ActivityBadgeStyle.danger,
      message: 'Akses ditolak: /admin/weather-rules',
      userId: 'user #14',
      ipAddress: '10.0.0.7',
      time: '09:11',
      category: ActivityCategory.admin,
    ),
  ];

  static const List<ApiLog> seedApiLogs = [
    ApiLog(
      id: '1',
      target: 'Jakarta',
      endpoint: '/weather',
      statusCode: 200,
      durationMs: 412,
      time: '09:52',
      type: ApiLogType.success,
    ),
    ApiLog(
      id: '2',
      target: 'Jakarta',
      endpoint: '/forecast',
      statusCode: 200,
      durationMs: 3,
      time: '09:52',
      type: ApiLogType.cacheHit,
    ),
    ApiLog(
      id: '3',
      target: 'Bandung',
      endpoint: '/air-pollution',
      statusCode: 200,
      durationMs: 368,
      time: '09:49',
      type: ApiLogType.success,
    ),
    ApiLog(
      id: '4',
      target: '-6.2349, 106.9896',
      endpoint: '/weather',
      statusCode: 200,
      durationMs: 401,
      time: '09:49',
      type: ApiLogType.success,
    ),
    ApiLog(
      id: '5',
      target: 'Kotaxyz',
      endpoint: '/weather',
      statusCode: 404,
      durationMs: 120,
      time: '09:40',
      type: ApiLogType.error,
    ),
    ApiLog(
      id: '6',
      target: 'Medan',
      endpoint: '/weather',
      statusCode: 200,
      durationMs: 4,
      time: '09:38',
      type: ApiLogType.cacheHit,
    ),
  ];

  @override
  Future<List<AppUser>> getUsers() async => seedUsers;

  @override
  Future<List<Role>> getRoles() async => seedRoles;

  @override
  Future<List<ActivityLog>> getActivityLogs() async => seedActivityLogs;

  @override
  Future<List<ApiLog>> getApiLogs() async => seedApiLogs;
}
