import 'package:flutter/material.dart';
import 'package:isra_fields_booking/core/theme/app_colors.dart';
import 'package:isra_fields_booking/core/theme/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? prefixIcon;
  final Color? backgroundColor;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.prefixIcon,
    this.backgroundColor,
    this.height = 52.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    final child = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutlined ? AppColors.primary : AppColors.textOnPrimary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, size: 18.0, color: isOutlined ? AppColors.primary : AppColors.textOnPrimary),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: AppTextStyles.button.copyWith(
                  color: isOutlined ? AppColors.primary : AppColors.textOnPrimary,
                ),
              ),
            ],
          );

    if (isOutlined) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: isDisabled ? AppColors.textHint : AppColors.primary,
              width: 1.5,
            ),
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? AppColors.textHint
              : (backgroundColor ?? AppColors.primary),
        ),
        child: child,
      ),
    );
  }
}