import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/weather_rule.dart';
import 'package:pemob/project/app/widgets/risk_chip.dart';

class FavoriteCityCard extends StatelessWidget {
  final String cityName;
  final String countryCode;
  final double temperature;
  final RiskLevel riskLevel;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  const FavoriteCityCard({
    super.key,
    required this.cityName,
    this.countryCode = 'ID',
    required this.temperature,
    required this.riskLevel,
    this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppDimensions.borderRadiusCard,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.cardPaddingDense),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppDimensions.borderRadiusCard,
          border: Border.all(color: AppColors.border, width: AppDimensions.borderWidth),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '$cityName, $countryCode',
                    style: AppTextStyles.bodyStrong.copyWith(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onRemove != null)
                  GestureDetector(
                    onTap: onRemove,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.close, size: 16, color: AppColors.textSecondary),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${temperature.toStringAsFixed(1)}°C',
              style: AppTextStyles.tempCard,
            ),
            const SizedBox(height: 12),
            RiskChip(level: riskLevel),
          ],
        ),
      ),
    );
  }
}

class AddFavoriteCityCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddFavoriteCityCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppDimensions.borderRadiusCard,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.cardPaddingDense),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: AppDimensions.borderRadiusCard,
          border: Border.all(
            color: AppColors.border,
            width: AppDimensions.borderWidth,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, size: 24, color: AppColors.textSecondary),
              const SizedBox(height: 6),
              Text(
                'Tambah kota',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
