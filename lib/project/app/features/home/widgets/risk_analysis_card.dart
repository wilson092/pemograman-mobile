import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/weather_rule.dart';
import 'package:pemob/project/app/data/risk_rules.dart';
import 'package:pemob/project/app/widgets/risk_chip.dart';
import 'package:pemob/project/app/widgets/risk_segmented.dart';

class RiskAnalysisCard extends StatelessWidget {
  final double temperature;
  final RiskLevel riskLevel;
  final List<WeatherRule> rules;

  const RiskAnalysisCard({
    super.key,
    required this.temperature,
    required this.riskLevel,
    required this.rules,
  });

  @override
  Widget build(BuildContext context) {
    final rangeText = RiskRuleHelper.formatRangeText(temperature, riskLevel, rules);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row: Title & Black Risk Chip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shield_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      'Analisis Risiko Cuaca',
                      style: AppTextStyles.titleCard.copyWith(fontSize: 14),
                    ),
                  ],
                ),
                RiskChip.dark(level: riskLevel),
              ],
            ),
            const SizedBox(height: 14),

            // Segmented 3 categories
            RiskSegmented(activeLevel: riskLevel),
            const SizedBox(height: 10),

            // Explanatory range text
            Text(
              rangeText,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
