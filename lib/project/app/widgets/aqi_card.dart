import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/air_quality.dart';
import 'package:pemob/project/app/widgets/risk_chip.dart';

class AqiCard extends StatelessWidget {
  final AirQuality aqi;
  final bool isCompact;

  const AqiCard({
    super.key,
    required this.aqi,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    // Normalization for progress bar (max 300)
    final progress = (aqi.index / 300.0).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.air_outlined, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  'Kualitas Udara (ISPU)',
                  style: AppTextStyles.titleCard.copyWith(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${aqi.index}',
                  style: AppTextStyles.displayStat,
                ),
                const SizedBox(width: 8),
                RiskChip(
                  customLabel: aqi.category,
                  level: null,
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Parameter kritis',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      aqi.criticalParameter,
                      style: AppTextStyles.bodyStrong.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Progress Bar
            Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.ispuBarFill,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Scale Labels
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0', style: AppTextStyles.caption),
                Text('100', style: AppTextStyles.caption),
                Text('200', style: AppTextStyles.caption),
                Text('300+', style: AppTextStyles.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
