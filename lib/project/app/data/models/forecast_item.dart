class HourlyForecast {
  final String time; // e.g. "12:00"
  final int temperature; // e.g. 31
  final String condition;
  final String icon;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.condition,
    this.icon = 'cloud',
  });
}

class DailyForecast {
  final String dayName; // e.g. "Senin"
  final String condition; // e.g. "Berawan"
  final int minTemp;
  final int maxTemp;
  final String icon;

  const DailyForecast({
    required this.dayName,
    required this.condition,
    required this.minTemp,
    required this.maxTemp,
    this.icon = 'cloud',
  });
}
