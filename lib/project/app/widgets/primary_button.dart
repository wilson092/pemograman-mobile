import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final bool isOutlined;
  final BorderSide? borderSide;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.onPrimary,
    this.height = AppDimensions.buttonHeight,
    this.isOutlined = false,
    this.borderSide,
  });

  const PrimaryButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.backgroundColor = Colors.transparent,
    this.textColor = AppColors.textPrimary,
    this.height = AppDimensions.buttonHeight,
    this.isOutlined = true,
    this.borderSide = const BorderSide(color: AppColors.border, width: 1),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          side: isOutlined ? borderSide : null,
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusButton,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (leadingIcon != null) ...[
              leadingIcon!,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: AppTextStyles.button.copyWith(color: textColor),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              trailingIcon!,
            ],
          ],
        ),
      ),
    );
  }
}
