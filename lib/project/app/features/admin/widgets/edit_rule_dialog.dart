import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/weather_rule.dart';
import 'package:pemob/project/app/widgets/app_text_field.dart';
import 'package:pemob/project/app/widgets/primary_button.dart';

class EditRuleDialog extends StatefulWidget {
  final WeatherRule rule;
  final Function(double newMin, double newMax) onSave;

  const EditRuleDialog({
    super.key,
    required this.rule,
    required this.onSave,
  });

  @override
  State<EditRuleDialog> createState() => _EditRuleDialogState();
}

class _EditRuleDialogState extends State<EditRuleDialog> {
  late final TextEditingController _minController;
  late final TextEditingController _maxController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _minController = TextEditingController(
      text: widget.rule.minTemp.toStringAsFixed(1),
    );
    _maxController = TextEditingController(
      text: widget.rule.maxTemp.toStringAsFixed(1),
    );
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final minVal = double.tryParse(_minController.text.replaceAll(',', '.'));
    final maxVal = double.tryParse(_maxController.text.replaceAll(',', '.'));

    if (minVal == null || maxVal == null) {
      setState(() {
        _errorMessage = 'Masukkan angka suhu yang valid';
      });
      return;
    }

    if (minVal >= maxVal) {
      setState(() {
        _errorMessage = 'Suhu minimum harus lebih kecil dari suhu maksimum';
      });
      return;
    }

    widget.onSave(minVal, maxVal);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Edit Rentang Suhu',
              style: AppTextStyles.titleCard.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Tingkat ${widget.rule.level.title} (${widget.rule.level.tierLabel})',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppDimensions.space16),

            AppTextField(
              label: 'Min Suhu (°C)',
              controller: _minController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            ),
            const SizedBox(height: AppDimensions.space12),

            AppTextField(
              label: 'Max Suhu (°C)',
              controller: _maxController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: AppTextStyles.caption.copyWith(color: AppColors.riskHigh, fontSize: 12),
              ),
            ],

            const SizedBox(height: AppDimensions.space20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(
                    text: 'Simpan',
                    onPressed: _handleSave,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
