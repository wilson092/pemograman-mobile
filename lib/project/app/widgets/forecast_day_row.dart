import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';

class ForecastDayRow extends StatelessWidget {
  final String dayName;
  final String condition;
  final int minTemp;
  final int maxTemp;
  final bool showDivider;

  const ForecastDayRow({
    super.key,
    required this.dayName,
    required this.condition,
    required this.minTemp,
    required this.maxTemp,
    this.showDivider = true,
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Text(
                  dayName,
                  style: AppTextStyles.bodyStrong.copyWith(fontSize: 13),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      _getIcon(),
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        condition,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$minTemp° / $maxTemp°',
                style: AppTextStyles.bodyStrong.copyWith(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}
