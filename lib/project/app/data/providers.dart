import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pemob/project/app/data/models/activity_log.dart';
import 'package:pemob/project/app/data/models/api_log.dart';
import 'package:pemob/project/app/data/models/app_user.dart';
import 'package:pemob/project/app/data/models/forecast_item.dart';
import 'package:pemob/project/app/data/models/role.dart';
import 'package:pemob/project/app/data/models/weather_data.dart';
import 'package:pemob/project/app/data/models/weather_rule.dart';
import 'package:pemob/project/app/data/repositories/admin_repository.dart';
import 'package:pemob/project/app/data/repositories/mock_admin_repository.dart';
import 'package:pemob/project/app/data/repositories/mock_weather_repository.dart';
import 'package:pemob/project/app/data/repositories/weather_repository.dart';
import 'package:pemob/project/app/data/risk_rules.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return MockWeatherRepository();
});

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return MockAdminRepository();
});

// Weather Rules Provider (In-memory reactive)
final weatherRulesProvider = StateProvider<List<WeatherRule>>((ref) {
  return List.from(RiskRuleHelper.initialRules);
});

// Currently selected city
final selectedCityWeatherProvider = StateProvider<WeatherData>((ref) {
  return MockWeatherRepository.seedCities.first;
});

// Forecast Providers
final hourlyForecastProvider = FutureProvider<List<HourlyForecast>>((ref) async {
  return ref.watch(weatherRepositoryProvider).getHourlyForecast();
});

final dailyForecastProvider = FutureProvider<List<DailyForecast>>((ref) async {
  return ref.watch(weatherRepositoryProvider).getDailyForecast();
});

// Favorite Cities
final favoriteCitiesProvider = StateProvider<List<WeatherData>>((ref) {
  return [
    MockWeatherRepository.seedCities.firstWhere((c) => c.city == 'Bandung'),
    MockWeatherRepository.seedCities.firstWhere((c) => c.city == 'Surabaya'),
    MockWeatherRepository.seedCities.firstWhere((c) => c.city == 'Medan'),
  ];
});

// Admin Providers
final adminUsersProvider = StateProvider<List<AppUser>>((ref) {
  return List.from(MockAdminRepository.seedUsers);
});

final adminRolesProvider = StateProvider<List<Role>>((ref) {
  return List.from(MockAdminRepository.seedRoles);
});

final activityLogsProvider = StateProvider<List<ActivityLog>>((ref) {
  return List.from(MockAdminRepository.seedActivityLogs);
});

final apiLogsProvider = StateProvider<List<ApiLog>>((ref) {
  return List.from(MockAdminRepository.seedApiLogs);
});
