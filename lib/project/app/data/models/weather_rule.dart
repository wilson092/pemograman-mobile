enum RiskLevel {
  rendah,
  sedang,
  tinggi;

  String get label {
    switch (this) {
      case RiskLevel.rendah:
        return 'RENDAH';
      case RiskLevel.sedang:
        return 'SEDANG';
      case RiskLevel.tinggi:
        return 'TINGGI';
    }
  }

  String get title {
    switch (this) {
      case RiskLevel.rendah:
        return 'Rendah';
      case RiskLevel.sedang:
        return 'Sedang';
      case RiskLevel.tinggi:
        return 'Tinggi';
    }
  }

  String get tierLabel {
    switch (this) {
      case RiskLevel.rendah:
        return 'TINGKAT 1';
      case RiskLevel.sedang:
        return 'TINGKAT 2';
      case RiskLevel.tinggi:
        return 'TINGKAT 3';
    }
  }
}

class WeatherRule {
  final RiskLevel level;
  final double minTemp;
  final double maxTemp;

  const WeatherRule({
    required this.level,
    required this.minTemp,
    required this.maxTemp,
  });

  WeatherRule copyWith({
    RiskLevel? level,
    double? minTemp,
    double? maxTemp,
  }) {
    return WeatherRule(
      level: level ?? this.level,
      minTemp: minTemp ?? this.minTemp,
      maxTemp: maxTemp ?? this.maxTemp,
    );
  }
}
