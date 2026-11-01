import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/weather_data.dart';
import 'package:pemob/project/app/data/models/weather_rule.dart';

class CompareSummaryCard extends StatelessWidget {
  final WeatherData cityA;
  final WeatherData cityB;
  final RiskLevel riskA;
  final RiskLevel riskB;

  const CompareSummaryCard({
    super.key,
    required this.cityA,
    required this.cityB,
    required this.riskA,
    required this.riskB,
  });

  String _getTempDiffText() {
    final diff = (cityA.temperature - cityB.temperature).abs();
    if (diff < 0.1) {
      return 'Kedua kota memiliki suhu yang sama (${cityA.temperature.toStringAsFixed(1)}°C)';
    } else if (cityA.temperature > cityB.temperature) {
      return '${cityA.city} lebih panas ${diff.toStringAsFixed(1)}°C dibanding ${cityB.city}';
    } else {
      return '${cityB.city} lebih panas ${diff.toStringAsFixed(1)}°C dibanding ${cityA.city}';
    }
  }

  String _getAqiDiffText() {
    final diff = (cityA.airQuality.index - cityB.airQuality.index).abs();
    if (diff == 0) {
      return 'Kualitas udara kedua kota sama (ISPU ${cityA.airQuality.index})';
    } else if (cityA.airQuality.index < cityB.airQuality.index) {
      return 'Kualitas udara ${cityA.city} lebih baik (selisih $diff poin)';
    } else {
      return 'Kualitas udara ${cityB.city} lebih baik (selisih $diff poin)';
    }
  }

  String _getRecommendationText() {
    if (riskA == RiskLevel.tinggi || riskB == RiskLevel.tinggi) {
      final highCity = riskA == RiskLevel.tinggi ? cityA.city : cityB.city;
      return 'Perhatikan peringatan risiko cuaca tinggi di $highCity, batasi aktivitas fisik berat di luar ruangan.';
    }
    if (riskA != riskB) {
      final lowerRiskCity = riskA == RiskLevel.rendah ? cityA.city : cityB.city;
      final higherRiskCity = riskA == RiskLevel.sedang ? cityA.city : cityB.city;
      return 'Kondisi cuaca di $lowerRiskCity lebih bersahabat untuk aktivitas luar ruangan dibanding $higherRiskCity.';
    }
    return 'Kondisi cuaca di kedua kota relatif setara dan aman untuk beraktivitas.';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics_outlined, size: 18, color: AppColors.textPrimary),
                const SizedBox(width: 8),
                Text(
                  'Ringkasan Perbandingan',
                  style: AppTextStyles.titleCard.copyWith(fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Suhu Diff
            _buildBulletPoint(
              icon: Icons.thermostat_outlined,
              text: _getTempDiffText(),
            ),
            const SizedBox(height: 10),

            // AQI Diff
            _buildBulletPoint(
              icon: Icons.air_outlined,
              text: _getAqiDiffText(),
            ),
            const SizedBox(height: 10),

            // Recommendation
            _buildBulletPoint(
              icon: Icons.lightbulb_outline,
              text: _getRecommendationText(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body.copyWith(fontSize: 13, height: 1.4),
          ),
        ),
      ],
    );
  }
}
