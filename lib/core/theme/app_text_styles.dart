import 'package:flutter/material.dart';
import 'package:isra_fields_booking/core/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle displayLarge = TextStyle(
    fontSize: 36, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, letterSpacing: -0.5, height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, letterSpacing: -0.3, height: 1.25,
  );

  static const TextStyle headingLarge = TextStyle(
    fontSize: 24, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, height: 1.3,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary, height: 1.35,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary, height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w400,
    color: AppColors.textPrimary, height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textPrimary, height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary, height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary, letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500,
    color: AppColors.textSecondary, letterSpacing: 0.15,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10, fontWeight: FontWeight.w500,
    color: AppColors.textHint, letterSpacing: 0.2,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary, letterSpacing: 0.5,
  );

  static const TextStyle input = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w400,
    color: AppColors.textPrimary, letterSpacing: 0.5,
  );

  static const TextStyle inputHint = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w400,
    color: AppColors.textHint,
  );

  static const TextStyle inputError = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: AppColors.error,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
  );
}