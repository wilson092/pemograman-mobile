import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';

class ServiceStatusCard extends StatelessWidget {
  const ServiceStatusCard({super.key});

  static const List<Map<String, String>> _services = [
    {'name': 'OpenWeatherMap API', 'status': '99.9% Operasional'},
    {'name': 'Database Utama', 'status': 'Normal'},
    {'name': 'Cache Layer (Redis)', 'status': 'Optimal'},
    {'name': 'Background Worker', 'status': 'Running'},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Layanan',
              style: AppTextStyles.titleCard.copyWith(fontSize: 15),
            ),
            const SizedBox(height: 12),
            ..._services.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.riskLow,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item['name']!,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      item['status']!,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 12,
                        color: AppColors.riskLow,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
