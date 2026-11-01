import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/weather_data.dart';
import 'package:pemob/project/app/data/models/weather_rule.dart';
import 'package:pemob/project/app/widgets/risk_chip.dart';

class CompareCityCard extends StatelessWidget {
  final WeatherData weather;
  final RiskLevel riskLevel;

  const CompareCityCard({
    super.key,
    required this.weather,
    required this.riskLevel,
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
      padding: const EdgeInsets.all(AppDimensions.cardPaddingDense),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppDimensions.borderRadiusCard,
        border: Border.all(color: AppColors.border, width: AppDimensions.borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // City Name & Risk Chip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${weather.city}, ${weather.countryCode}',
                  style: AppTextStyles.bodyStrong.copyWith(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              RiskChip(level: riskLevel),
            ],
          ),
          const SizedBox(height: 10),

          // Temp & Icon & Condition
          Row(
            children: [
              Icon(_getWeatherIcon(weather.condition), size: 28, color: AppColors.textPrimary),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature.toStringAsFixed(1)}°C',
                      style: AppTextStyles.tempCard.copyWith(fontSize: 20),
                    ),
                    Text(
                      weather.condition,
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Mini metrics
          _buildMetricRow('Kelembapan', '${weather.humidity}%'),
          const SizedBox(height: 6),
          _buildMetricRow('Tekanan', '${weather.pressure} hPa'),
          const SizedBox(height: 6),
          _buildMetricRow('Angin', '${weather.windSpeed.toStringAsFixed(1)} m/s'),
          const SizedBox(height: 6),
          _buildMetricRow(
            'ISPU',
            '${weather.airQuality.index} (${weather.airQuality.category.toUpperCase()})',
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
