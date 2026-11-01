import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/providers.dart';
import 'package:pemob/project/app/features/admin/widgets/admin_stat_card.dart';
import 'package:pemob/project/app/features/admin/widgets/recent_activity_card.dart';
import 'package:pemob/project/app/features/admin/widgets/service_status_card.dart';
import 'package:pemob/project/app/widgets/admin_top_bar.dart';

class AdminOverviewScreen extends ConsumerWidget {
  const AdminOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(weatherRulesProvider);
    final activityLogs = ref.watch(activityLogsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AdminTopBar(
        title: 'Overview',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data overview diperbarui')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.textPrimary, size: 22),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
          vertical: AppDimensions.space16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 2x2 Grid of StatCards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.45,
              children: [
                const AdminStatCard(
                  title: 'Total Pengguna',
                  value: '1.248',
                  subtitle: '+12% bulan ini',
                  subtitleColor: AppColors.riskLow,
                ),
                AdminStatCard(
                  title: 'Aturan Cuaca',
                  value: '${rules.length} Aturan',
                  subtitle: 'Semua aktif',
                  subtitleColor: AppColors.riskLow,
                ),
                const AdminStatCard(
                  title: 'API Calls (24j)',
                  value: '48.2K',
                  subtitle: '99.8% sukses',
                  subtitleColor: AppColors.riskLow,
                ),
                AdminStatCard(
                  title: 'Status Sistem',
                  value: 'OPERASIONAL',
                  badge: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.riskLow.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'ALL SYSTEMS NORMAL',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.riskLow,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space16),

            // Aktivitas Terakhir Card
            RecentActivityCard(logs: activityLogs),
            const SizedBox(height: AppDimensions.space16),

            // Status Layanan Card
            const ServiceStatusCard(),
            const SizedBox(height: AppDimensions.space24),
          ],
        ),
      ),
    );
  }
}

