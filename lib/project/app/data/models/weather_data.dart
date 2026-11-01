import 'package:pemob/project/app/data/models/air_quality.dart';
import 'package:pemob/project/app/data/models/weather_rule.dart';

class WeatherData {
  final String city;
  final String countryCode;
  final double temperature;
  final String condition;
  final int humidity; // in %
  final int pressure; // in hPa
  final double windSpeed; // in m/s
  final AirQuality airQuality;
  final RiskLevel? riskOverride; // Bandung override per design.md decision #7
  final double? lat;
  final double? lon;

  double get latitude => lat ?? 0.0;
  double get longitude => lon ?? 0.0;

  const WeatherData({
    required this.city,
    this.countryCode = 'ID',
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.airQuality,
    this.riskOverride,
    this.lat,
    this.lon,
  });

  WeatherData copyWith({
    String? city,
    String? countryCode,
    double? temperature,
    String? condition,
    int? humidity,
    int? pressure,
    double? windSpeed,
    AirQuality? airQuality,
    RiskLevel? riskOverride,
    double? lat,
    double? lon,
  }) {
    return WeatherData(
      city: city ?? this.city,
      countryCode: countryCode ?? this.countryCode,
      temperature: temperature ?? this.temperature,
      condition: condition ?? this.condition,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
      windSpeed: windSpeed ?? this.windSpeed,
      airQuality: airQuality ?? this.airQuality,
      riskOverride: riskOverride ?? this.riskOverride,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }
}
