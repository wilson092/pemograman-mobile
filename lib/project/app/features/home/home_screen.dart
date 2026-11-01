import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/weather_data.dart';
import 'package:pemob/project/app/data/providers.dart';
import 'package:pemob/project/app/data/repositories/mock_weather_repository.dart';
import 'package:pemob/project/app/data/risk_rules.dart';
import 'package:pemob/project/app/features/home/widgets/favorite_cities_grid.dart';
import 'package:pemob/project/app/features/home/widgets/forecast_sections.dart';
import 'package:pemob/project/app/features/home/widgets/live_conditions_card.dart';
import 'package:pemob/project/app/features/home/widgets/risk_analysis_card.dart';
import 'package:pemob/project/app/widgets/aqi_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  String? _searchError;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchCity(String query) {
    if (query.trim().isEmpty) return;
    const allCities = MockWeatherRepository.seedCities;
    final found = allCities.where(
      (c) => c.city.toLowerCase() == query.trim().toLowerCase(),
    );

    if (found.isNotEmpty) {
      ref.read(selectedCityWeatherProvider.notifier).state = found.first;
      setState(() => _searchError = null);
    } else {
      setState(() => _searchError = 'Kota tidak ditemukan');
    }
  }

  void _addNextFavoriteCity() {
    final currentFavorites = ref.read(favoriteCitiesProvider);
    const allCities = MockWeatherRepository.seedCities;

    WeatherData? nextCandidate;
    for (final city in allCities) {
      if (!currentFavorites.any((f) => f.city == city.city)) {
        nextCandidate = city;
        break;
      }
    }

    if (nextCandidate != null) {
      ref.read(favoriteCitiesProvider.notifier).state = [
        ...currentFavorites,
        nextCandidate,
      ];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${nextCandidate.city} ditambahkan ke favorit')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kota sudah ada di favorit')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWeather = ref.watch(selectedCityWeatherProvider);
    final rules = ref.watch(weatherRulesProvider);
    final favorites = ref.watch(favoriteCitiesProvider);
    final hourlyAsync = ref.watch(hourlyForecastProvider);
    final dailyAsync = ref.watch(dailyForecastProvider);

    final currentRisk = RiskRuleHelper.calculateRisk(
      currentWeather.temperature,
      rules,
      override: currentWeather.riskOverride,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
          vertical: AppDimensions.space12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              onSubmitted: _searchCity,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Cari kota...',
                prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchError = null);
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
            if (_searchError != null) ...[
              const SizedBox(height: 4),
              Text(
                _searchError!,
                style: AppTextStyles.caption.copyWith(color: AppColors.error),
              ),
            ],
            const SizedBox(height: AppDimensions.space16),

            LiveConditionsCard(weather: currentWeather),
            const SizedBox(height: AppDimensions.space12),

            RiskAnalysisCard(
              temperature: currentWeather.temperature,
              riskLevel: currentRisk,
              rules: rules,
            ),
            const SizedBox(height: AppDimensions.space12),

            AqiCard(aqi: currentWeather.airQuality),
            const SizedBox(height: AppDimensions.space20),

            HourlyForecastSection(hourlyAsync: hourlyAsync),
            const SizedBox(height: AppDimensions.space20),

            DailyForecastSection(dailyAsync: dailyAsync),
            const SizedBox(height: AppDimensions.space20),

            FavoriteCitiesGrid(
              favorites: favorites,
              rules: rules,
              onSelectCity: (city) {
                ref.read(selectedCityWeatherProvider.notifier).state = city;
              },
              onRemoveCity: (cityName) {
                final current = ref.read(favoriteCitiesProvider);
                ref.read(favoriteCitiesProvider.notifier).state =
                    current.where((c) => c.city != cityName).toList();
              },
              onAddCity: _addNextFavoriteCity,
            ),
            const SizedBox(height: AppDimensions.space24),
          ],
        ),
      ),
    );
  }
}

