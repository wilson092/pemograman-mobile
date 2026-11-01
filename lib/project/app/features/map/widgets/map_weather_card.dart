import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/weather_data.dart';
import 'package:pemob/project/app/data/models/weather_rule.dart';
import 'package:pemob/project/app/widgets/risk_chip.dart';

class MapWeatherCard extends StatelessWidget {
  final WeatherData weather;
  final RiskLevel riskLevel;
  final VoidCallback onClose;

  const MapWeatherCard({
    super.key,
    required this.weather,
    required this.riskLevel,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppDimensions.borderRadiusCard,
        border: Border.all(color: AppColors.border, width: AppDimensions.borderWidth),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Row: City Name, RiskChip, Close Button
          Row(
            children: [
              Expanded(
                child: Text(
                  '${weather.city}, ${weather.countryCode}',
                  style: AppTextStyles.titleCard.copyWith(fontSize: 15),
                ),
              ),
              RiskChip(level: riskLevel),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClose,
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Middle Row: Temp & Condition
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${weather.temperature.toStringAsFixed(1)}°C',
                style: AppTextStyles.displayTemp.copyWith(fontSize: 28),
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
          const SizedBox(height: 12),

          // Bottom Mini Stats
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniStat('Kelembapan', '${weather.humidity}%'),
                Container(height: 20, width: 1, color: AppColors.border),
                _buildMiniStat('Angin', '${weather.windSpeed.toStringAsFixed(1)} m/s'),
                Container(height: 20, width: 1, color: AppColors.border),
                _buildMiniStat('ISPU', '${weather.airQuality.aqi}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.bodyStrong.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}
