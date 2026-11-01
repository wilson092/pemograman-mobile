class AirQuality {
  final int index;
  int get aqi => index;
  final String category; // e.g. "SEDANG", "Baik"
  final String criticalParameter; // e.g. "PM2.5"
  final String details; // e.g. "PM2.5 (34 μg/m³)"

  const AirQuality({
    required this.index,
    required this.category,
    required this.criticalParameter,
    this.details = '',
  });
}
