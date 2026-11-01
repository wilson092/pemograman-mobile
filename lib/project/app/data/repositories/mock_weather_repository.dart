import 'package:pemob/project/app/data/models/air_quality.dart';
import 'package:pemob/project/app/data/models/forecast_item.dart';
import 'package:pemob/project/app/data/models/weather_data.dart';
import 'package:pemob/project/app/data/models/weather_rule.dart';
import 'package:pemob/project/app/data/repositories/weather_repository.dart';

class MockWeatherRepository implements WeatherRepository {
  static const List<WeatherData> seedCities = [
    WeatherData(
      city: 'Jakarta',
      countryCode: 'ID',
      temperature: 31.4,
      condition: 'Berawan',
      humidity: 78,
      pressure: 1009,
      windSpeed: 3.2,
      airQuality: AirQuality(
        index: 62,
        category: 'SEDANG',
        criticalParameter: 'PM2.5',
      ),
      lat: -6.2088,
      lon: 106.8456,
    ),
    WeatherData(
      city: 'Bandung',
      countryCode: 'ID',
      temperature: 24.8,
      condition: 'Hujan Ringan',
      humidity: 84,
      pressure: 1012,
      windSpeed: 2.1,
      airQuality: AirQuality(
        index: 38,
        category: 'Baik',
        criticalParameter: 'PM2.5',
      ),
      // Decision #7 in design.md: Bandung 24.8°C has riskOverride = rendah
      // to match mockup 03_beranda_bawah.png and 05_perbandingan.png
      riskOverride: RiskLevel.rendah,
      lat: -6.9175,
      lon: 107.6191,
    ),
    WeatherData(
      city: 'Bekasi',
      countryCode: 'ID',
      temperature: 32.1,
      condition: 'Cerah Berawan',
      humidity: 74,
      pressure: 1008,
      windSpeed: 2.8,
      airQuality: AirQuality(
        index: 58,
        category: 'SEDANG',
        criticalParameter: 'PM2.5',
        details: 'PM2.5 (34 μg/m³)',
      ),
      lat: -6.2349,
      lon: 106.9896,
    ),
    WeatherData(
      city: 'Surabaya',
      countryCode: 'ID',
      temperature: 34.1,
      condition: 'Cerah',
      humidity: 68, // dummy
      pressure: 1010, // dummy
      windSpeed: 4.0, // dummy
      airQuality: AirQuality(
        index: 55, // dummy
        category: 'SEDANG',
        criticalParameter: 'PM2.5',
      ),
      lat: -7.2575,
      lon: 112.7521,
    ),
    WeatherData(
      city: 'Medan',
      countryCode: 'ID',
      temperature: 36.2,
      condition: 'Cerah Berawan',
      humidity: 65, // dummy
      pressure: 1007, // dummy
      windSpeed: 3.8, // dummy
      airQuality: AirQuality(
        index: 70, // dummy
        category: 'SEDANG',
        criticalParameter: 'PM2.5',
      ),
      lat: 3.5952,
      lon: 98.6722,
    ),
    WeatherData(
      city: 'Malang',
      countryCode: 'ID',
      temperature: 26.5, // dummy
      condition: 'Berawan', // dummy
      humidity: 80, // dummy
      pressure: 1011, // dummy
      windSpeed: 2.5, // dummy
      airQuality: AirQuality(
        index: 42, // dummy
        category: 'Baik',
        criticalParameter: 'PM2.5',
      ),
      lat: -7.9666,
      lon: 112.6326,
    ),
    WeatherData(
      city: 'Jogja',
      countryCode: 'ID',
      temperature: 30.2, // dummy
      condition: 'Cerah Berawan', // dummy
      humidity: 72, // dummy
      pressure: 1009, // dummy
      windSpeed: 3.0, // dummy
      airQuality: AirQuality(
        index: 48, // dummy
        category: 'Baik',
        criticalParameter: 'PM2.5',
      ),
      lat: -7.7956,
      lon: 110.3695,
    ),
    WeatherData(
      city: 'Solo',
      countryCode: 'ID',
      temperature: 31.0, // dummy
      condition: 'Cerah', // dummy
      humidity: 70, // dummy
      pressure: 1010, // dummy
      windSpeed: 3.1, // dummy
      airQuality: AirQuality(
        index: 52, // dummy
        category: 'SEDANG',
        criticalParameter: 'PM2.5',
      ),
      lat: -7.5755,
      lon: 110.8243,
    ),
  ];

  static const List<HourlyForecast> _seedHourly = [
    HourlyForecast(time: '12:00', temperature: 31, condition: 'Berawan'),
    HourlyForecast(time: '15:00', temperature: 32, condition: 'Cerah Berawan'),
    HourlyForecast(time: '18:00', temperature: 29, condition: 'Berawan'),
    HourlyForecast(time: '21:00', temperature: 27, condition: 'Berawan'),
    HourlyForecast(time: '00:00', temperature: 26, condition: 'Cerah'), // dummy
    HourlyForecast(time: '03:00', temperature: 25, condition: 'Cerah'), // dummy
    HourlyForecast(time: '06:00', temperature: 25, condition: 'Cerah'), // dummy
    HourlyForecast(time: '09:00', temperature: 28, condition: 'Cerah Berawan'), // dummy
  ];

  static const List<DailyForecast> _seedDaily = [
    DailyForecast(dayName: 'Senin', condition: 'Berawan', minTemp: 26, maxTemp: 32),
    DailyForecast(dayName: 'Selasa', condition: 'Hujan Ringan', minTemp: 25, maxTemp: 30),
    DailyForecast(dayName: 'Rabu', condition: 'Berawan', minTemp: 26, maxTemp: 33),
    DailyForecast(dayName: 'Kamis', condition: 'Cerah', minTemp: 26, maxTemp: 34),
    DailyForecast(dayName: 'Jumat', condition: 'Hujan', minTemp: 25, maxTemp: 29),
  ];

  @override
  Future<WeatherData?> getWeatherByCity(String cityName) async {
    final query = cityName.trim().toLowerCase();
    try {
      return seedCities.firstWhere(
        (c) => c.city.toLowerCase() == query,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<HourlyForecast>> getHourlyForecast() async {
    return _seedHourly;
  }

  @override
  Future<List<DailyForecast>> getDailyForecast() async {
    return _seedDaily;
  }

  @override
  Future<List<WeatherData>> getFavoriteCities() async {
    // Initial favorite cities in 03_beranda_bawah.png: Bandung, Surabaya, Medan
    return [
      seedCities.firstWhere((c) => c.city == 'Bandung'),
      seedCities.firstWhere((c) => c.city == 'Surabaya'),
      seedCities.firstWhere((c) => c.city == 'Medan'),
    ];
  }

  @override
  Future<List<WeatherData>> getAllCities() async {
    return seedCities;
  }
}
