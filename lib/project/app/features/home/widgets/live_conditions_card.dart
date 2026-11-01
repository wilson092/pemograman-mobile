import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/weather_data.dart';
import 'package:pemob/project/app/widgets/stat_tile.dart';

class LiveConditionsCard extends StatelessWidget {
  final WeatherData weather;

  const LiveConditionsCard({
    super.key,
    required this.weather,
  });

  IconData _getWeatherIcon(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('hujan')) return Icons.water_drop_outlined;
    if (c.contains('cerah berawan')) return Icons.wb_cloudy_outlined;
    if (c.contains('cerah')) return Icons.wb_sunny_outlined;
    return Icons.wb_cloudy_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: AppDimensions.borderRadiusCard,
        border: Border.all(color: AppColors.border, width: AppDimensions.borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: LIVE CONDITIONS & Weather Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'LIVE CONDITIONS',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${weather.city}, ${weather.countryCode}',
                    style: AppTextStyles.titleCard.copyWith(fontSize: 16),
                  ),
                ],
              ),
              Icon(
                _getWeatherIcon(weather.condition),
                size: 36,
                color: AppColors.textPrimary,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Big Temp & Condition
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${weather.temperature.toStringAsFixed(1)}°C',
                style: AppTextStyles.displayTemp,
              ),
              const SizedBox(width: 10),
              Text(
                weather.condition,
                style: AppTextStyles.bodyStrong.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Embedded White Stat Tiles Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
              border: Border.all(color: AppColors.border, width: AppDimensions.borderWidth),
            ),
            child: Row(
              children: [
                Expanded(
                  child: StatTile(
                    icon: Icons.water_drop_outlined,
                    label: 'Kelembapan',
                    labelColor: AppColors.accentBlueLight,
                    value: '${weather.humidity}',
                    unit: '%',
                  ),
                ),
                Container(height: 28, width: 1, color: AppColors.border),
                const SizedBox(width: 12),
                Expanded(
                  child: StatTile(
                    icon: Icons.speed_outlined,
                    label: 'Tekanan',
                    labelColor: AppColors.statPressure,
                    value: '${weather.pressure}',
                    unit: 'hPa',
                  ),
                ),
                Container(height: 28, width: 1, color: AppColors.border),
                const SizedBox(width: 12),
                Expanded(
                  child: StatTile(
                    icon: Icons.air_outlined,
                    label: 'Angin',
                    labelColor: AppColors.statWind,
                    value: weather.windSpeed.toStringAsFixed(1),
                    unit: 'm/s',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
