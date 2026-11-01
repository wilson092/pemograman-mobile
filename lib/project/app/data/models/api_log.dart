enum ApiLogType {
  success,
  cacheHit,
  error;

  String get label {
    switch (this) {
      case ApiLogType.success:
        return 'SUCCESS';
      case ApiLogType.cacheHit:
        return 'CACHE_HIT';
      case ApiLogType.error:
        return 'ERROR';
    }
  }
}

class ApiLog {
  final String id;
  final String target; // e.g. "Jakarta", "-6.2349, 106.9896"
  final String endpoint; // e.g. "/weather"
  final int statusCode; // e.g. 200, 404
  final int durationMs; // e.g. 412
  final String time; // e.g. "09:52"
  final ApiLogType type;

  const ApiLog({
    required this.id,
    required this.target,
    required this.endpoint,
    required this.statusCode,
    required this.durationMs,
    required this.time,
    required this.type,
  });
}
