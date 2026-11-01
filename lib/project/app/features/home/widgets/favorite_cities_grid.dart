import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/data/models/weather_data.dart';
import 'package:pemob/project/app/data/models/weather_rule.dart';
import 'package:pemob/project/app/data/risk_rules.dart';
import 'package:pemob/project/app/widgets/favorite_city_card.dart';
import 'package:pemob/project/app/widgets/section_header.dart';

class FavoriteCitiesGrid extends StatelessWidget {
  final List<WeatherData> favorites;
  final List<WeatherRule> rules;
  final ValueChanged<WeatherData> onSelectCity;
  final ValueChanged<String> onRemoveCity;
  final VoidCallback onAddCity;

  const FavoriteCitiesGrid({
    super.key,
    required this.favorites,
    required this.rules,
    required this.onSelectCity,
    required this.onRemoveCity,
    required this.onAddCity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Kota Favorit',
          actionText: '+ Tambah',
          onActionTap: onAddCity,
        ),
        const SizedBox(height: AppDimensions.space12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.25,
          ),
          itemCount: favorites.length + 1,
          itemBuilder: (context, index) {
            if (index < favorites.length) {
              final fav = favorites[index];
              final risk = RiskRuleHelper.calculateRisk(
                fav.temperature,
                rules,
                override: fav.riskOverride,
              );
              return FavoriteCityCard(
                cityName: fav.city,
                countryCode: fav.countryCode,
                temperature: fav.temperature,
                riskLevel: risk,
                onTap: () => onSelectCity(fav),
                onRemove: () => onRemoveCity(fav.city),
              );
            } else {
              return AddFavoriteCityCard(onTap: onAddCity);
            }
          },
        ),
      ],
    );
  }
}
