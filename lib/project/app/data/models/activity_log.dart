enum ActivityCategory {
  semua,
  autentikasi,
  favorit,
  admin,
}

enum ActivityBadgeStyle {
  success,
  neutral,
  error,
  danger,
}

class ActivityLog {
  final String id;
  final String actionCode; // e.g. "LOGIN_SUCCESS"
  final String badgeText; // e.g. "Berhasil", "Pref", "Auth Gagal", "Config", "Role", "Security 403"
  final ActivityBadgeStyle badgeStyle;
  final String message;
  final String? userId; // e.g. "user #12" or null
  final String ipAddress; // e.g. "10.0.0.5"
  final String time; // e.g. "09:52"
  final ActivityCategory category;

  const ActivityLog({
    required this.id,
    required this.actionCode,
    required this.badgeText,
    this.badgeStyle = ActivityBadgeStyle.neutral,
    required this.message,
    this.userId,
    required this.ipAddress,
    required this.time,
    required this.category,
  });
}
