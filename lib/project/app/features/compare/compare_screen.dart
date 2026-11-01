import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/weather_data.dart';
import 'package:pemob/project/app/data/providers.dart';
import 'package:pemob/project/app/data/repositories/mock_weather_repository.dart';
import 'package:pemob/project/app/data/risk_rules.dart';
import 'package:pemob/project/app/features/compare/widgets/city_dropdown.dart';
import 'package:pemob/project/app/features/compare/widgets/compare_city_card.dart';
import 'package:pemob/project/app/features/compare/widgets/compare_summary_card.dart';

class CompareScreen extends ConsumerStatefulWidget {
  const CompareScreen({super.key});

  @override
  ConsumerState<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends ConsumerState<CompareScreen> {
  late WeatherData _cityA;
  late WeatherData _cityB;

  @override
  void initState() {
    super.initState();
    const cities = MockWeatherRepository.seedCities;
    _cityA = cities.firstWhere((c) => c.city == 'Jakarta', orElse: () => cities[0]);
    _cityB = cities.firstWhere((c) => c.city == 'Bandung', orElse: () => cities[1]);
  }

  void _onSelectCityA(String? newCityName) {
    if (newCityName == null) return;
    if (newCityName == _cityB.city) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kota yang berbeda')),
      );
      return;
    }
    final selected = MockWeatherRepository.seedCities.firstWhere((c) => c.city == newCityName);
    setState(() => _cityA = selected);
  }

  void _onSelectCityB(String? newCityName) {
    if (newCityName == null) return;
    if (newCityName == _cityA.city) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kota yang berbeda')),
      );
      return;
    }
    final selected = MockWeatherRepository.seedCities.firstWhere((c) => c.city == newCityName);
    setState(() => _cityB = selected);
  }

  @override
  Widget build(BuildContext context) {
    final rules = ref.watch(weatherRulesProvider);

    final riskA = RiskRuleHelper.calculateRisk(
      _cityA.temperature,
      rules,
      override: _cityA.riskOverride,
    );
    final riskB = RiskRuleHelper.calculateRisk(
      _cityB.temperature,
      rules,
      override: _cityB.riskOverride,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
          vertical: AppDimensions.space16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pilih 2 Kota untuk Dibandingkan',
              style: AppTextStyles.titleCard.copyWith(fontSize: 15),
            ),
            const SizedBox(height: AppDimensions.space12),

            Row(
              children: [
                Expanded(
                  child: CityDropdown(
                    label: 'KOTA A',
                    selectedValue: _cityA.city,
                    onChanged: _onSelectCityA,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CityDropdown(
                    label: 'KOTA B',
                    selectedValue: _cityB.city,
                    onChanged: _onSelectCityB,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CompareCityCard(
                    weather: _cityA,
                    riskLevel: riskA,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CompareCityCard(
                    weather: _cityB,
                    riskLevel: riskB,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space20),

            CompareSummaryCard(
              cityA: _cityA,
              cityB: _cityB,
              riskA: riskA,
              riskB: riskB,
            ),
            const SizedBox(height: AppDimensions.space24),
          ],
        ),
      ),
    );
  }
}

