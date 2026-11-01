import 'package:pemob/project/app/data/models/activity_log.dart';
import 'package:pemob/project/app/data/models/api_log.dart';
import 'package:pemob/project/app/data/models/app_user.dart';
import 'package:pemob/project/app/data/models/role.dart';

abstract class AdminRepository {
  Future<List<AppUser>> getUsers();
  Future<List<Role>> getRoles();
  Future<List<ActivityLog>> getActivityLogs();
  Future<List<ApiLog>> getApiLogs();
}
