import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/weather_rule.dart';

class RiskChip extends StatelessWidget {
  final RiskLevel? level;
  final String? customLabel;
  final bool isDark; // If true, renders black background with white text

  const RiskChip({
    super.key,
    this.level,
    this.customLabel,
    this.isDark = false,
  });

  const RiskChip.dark({
    super.key,
    this.level,
    this.customLabel,
  }) : isDark = true;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    if (isDark) {
      bg = AppColors.primary;
      fg = AppColors.onPrimary;
    } else {
      switch (level ?? RiskLevel.sedang) {
        case RiskLevel.rendah:
          bg = AppColors.riskLowBg;
          fg = AppColors.riskLow;
          break;
        case RiskLevel.sedang:
          bg = AppColors.riskMediumBg;
          fg = AppColors.riskMedium;
          break;
        case RiskLevel.tinggi:
          bg = AppColors.riskHighBg;
          fg = AppColors.riskHigh;
          break;
      }
    }

    final text = customLabel ?? (level?.label ?? 'SEDANG');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppDimensions.borderRadiusChip,
      ),
      child: Text(
        text,
        style: AppTextStyles.chip.copyWith(color: fg),
      ),
    );
  }
}
