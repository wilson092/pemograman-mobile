import 'package:pemob/project/app/data/models/forecast_item.dart';
import 'package:pemob/project/app/data/models/weather_data.dart';

abstract class WeatherRepository {
  Future<WeatherData?> getWeatherByCity(String cityName);
  Future<List<HourlyForecast>> getHourlyForecast();
  Future<List<DailyForecast>> getDailyForecast();
  Future<List<WeatherData>> getFavoriteCities();
  Future<List<WeatherData>> getAllCities();
}
