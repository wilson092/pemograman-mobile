import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/weather_rule.dart';

class MapMarkerWidget extends StatelessWidget {
  final String cityName;
  final double temperature;
  final RiskLevel riskLevel;
  final bool isSelected;
  final VoidCallback onTap;

  const MapMarkerWidget({
    super.key,
    required this.cityName,
    required this.temperature,
    required this.riskLevel,
    this.isSelected = false,
    required this.onTap,
  });

  Color _getDotColor() {
    switch (riskLevel) {
      case RiskLevel.rendah:
        return AppColors.riskLow;
      case RiskLevel.sedang:
        return AppColors.riskMedium;
      case RiskLevel.tinggi:
        return AppColors.riskHigh;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dotColor = _getDotColor();

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circle Pin
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.textPrimary : AppColors.border,
                width: isSelected ? 2 : 1.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),

          // Label Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.textPrimary : AppColors.border,
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              '$cityName • ${temperature.toStringAsFixed(1)}°',
              style: AppTextStyles.caption.copyWith(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
