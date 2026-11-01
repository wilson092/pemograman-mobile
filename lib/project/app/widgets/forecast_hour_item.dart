import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';

class ForecastHourItem extends StatelessWidget {
  final String time;
  final int temperature;
  final String condition;

  const ForecastHourItem({
    super.key,
    required this.time,
    required this.temperature,
    required this.condition,
  });

  IconData _getIcon() {
    final c = condition.toLowerCase();
    if (c.contains('hujan')) return Icons.water_drop_outlined;
    if (c.contains('cerah berawan')) return Icons.wb_cloudy_outlined;
    if (c.contains('cerah')) return Icons.wb_sunny_outlined;
    return Icons.cloud_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
        border: Border.all(color: AppColors.border, width: AppDimensions.borderWidth),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            time,
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
          ),
          Icon(
            _getIcon(),
            size: 20,
            color: AppColors.textPrimary,
          ),
          Text(
            '$temperature°',
            style: AppTextStyles.bodyStrong.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
