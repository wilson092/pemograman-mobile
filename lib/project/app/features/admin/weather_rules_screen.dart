import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/weather_rule.dart';
import 'package:pemob/project/app/data/providers.dart';
import 'package:pemob/project/app/features/admin/widgets/edit_rule_dialog.dart';
import 'package:pemob/project/app/features/admin/widgets/rule_card.dart';
import 'package:pemob/project/app/widgets/admin_top_bar.dart';

class WeatherRulesScreen extends ConsumerWidget {
  const WeatherRulesScreen({super.key});

  void _showEditDialog(BuildContext context, WidgetRef ref, WeatherRule rule) {
    showDialog(
      context: context,
      builder: (dialogCtx) => EditRuleDialog(
        rule: rule,
        onSave: (newMin, newMax) {
          final currentRules = List<WeatherRule>.from(ref.read(weatherRulesProvider));

          final updated = currentRules.map((r) {
            if (r.level == rule.level) {
              return r.copyWith(minTemp: newMin, maxTemp: newMax);
            }
            // Auto sync adjacent boundaries
            if (rule.level == RiskLevel.rendah && r.level == RiskLevel.sedang) {
              return r.copyWith(minTemp: newMax);
            }
            if (rule.level == RiskLevel.sedang) {
              if (r.level == RiskLevel.rendah) return r.copyWith(maxTemp: newMin);
              if (r.level == RiskLevel.tinggi) return r.copyWith(minTemp: newMax);
            }
            if (rule.level == RiskLevel.tinggi && r.level == RiskLevel.sedang) {
              return r.copyWith(maxTemp: newMin);
            }
            return r;
          }).toList();

          ref.read(weatherRulesProvider.notifier).state = updated;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Aturan berhasil diperbarui')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(weatherRulesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AdminTopBar(
        title: 'Aturan Cuaca',
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Aturan cuaca sudah mencakup 3 tingkat risiko lengkap'),
                ),
              );
            },
            icon: const Icon(Icons.add, size: 18, color: AppColors.textPrimary),
            label: const Text(
              'Tambah',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
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
            // Banner Info
            Container(
              padding: const EdgeInsets.all(AppDimensions.cardPaddingDense),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                border: Border.all(color: AppColors.border, width: AppDimensions.borderWidth),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 20, color: AppColors.textSecondary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Aturan ini menentukan klasifikasi risiko cuaca yang tampil di sisi pengguna secara otomatis.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space16),

            // 3 Rule Cards
            ...rules.map((rule) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.space12),
                child: RuleCard(
                  rule: rule,
                  onEdit: () => _showEditDialog(context, ref, rule),
                ),
              );
            }),
            const SizedBox(height: AppDimensions.space20),
          ],
        ),
      ),
    );
  }
}

