import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/weather_rule.dart';
import 'package:pemob/project/app/widgets/risk_chip.dart';

class RuleCard extends StatelessWidget {
  final WeatherRule rule;
  final VoidCallback onEdit;

  const RuleCard({
    super.key,
    required this.rule,
    required this.onEdit,
  });

  String _getRangeText() {
    switch (rule.level) {
      case RiskLevel.rendah:
        return '< ${rule.maxTemp.toStringAsFixed(1)}°C';
      case RiskLevel.sedang:
        return '${rule.minTemp.toStringAsFixed(1)}°C – ${rule.maxTemp.toStringAsFixed(1)}°C';
      case RiskLevel.tinggi:
        return '≥ ${rule.minTemp.toStringAsFixed(1)}°C';
    }
  }

  String _getDescription() {
    switch (rule.level) {
      case RiskLevel.rendah:
        return 'Cuaca nyaman dan aman untuk aktivitas luar ruangan normal.';
      case RiskLevel.sedang:
        return 'Waspada kondisi panas/lembab sedang, disarankan cukup hidrasi.';
      case RiskLevel.tinggi:
        return 'Risiko cuaca ekstrem, batasi aktivitas fisik di luar ruangan.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Chip + Tier + Edit Button
            Row(
              children: [
                RiskChip(level: rule.level),
                const SizedBox(width: 8),
                Text(
                  rule.level.tierLabel,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.riskLow.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Aktif',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.riskLow,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textPrimary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Edit Aturan',
                  onPressed: onEdit,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Rentang Suhu
            Row(
              children: [
                const Icon(Icons.thermostat_outlined, size: 20, color: AppColors.textPrimary),
                const SizedBox(width: 8),
                Text(
                  _getRangeText(),
                  style: AppTextStyles.titleCard.copyWith(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              _getDescription(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
