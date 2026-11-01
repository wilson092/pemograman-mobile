import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/repositories/mock_weather_repository.dart';

class CityDropdown extends StatelessWidget {
  final String label;
  final String selectedValue;
  final ValueChanged<String?> onChanged;

  const CityDropdown({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const cities = MockWeatherRepository.seedCities;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
            border: Border.all(color: AppColors.border, width: AppDimensions.borderWidth),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
              style: AppTextStyles.bodyStrong.copyWith(fontSize: 13, color: AppColors.textPrimary),
              onChanged: onChanged,
              items: cities.map((c) {
                return DropdownMenuItem<String>(
                  value: c.city,
                  child: Text(c.city),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
