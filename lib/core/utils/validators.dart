import 'package:isra_fields_booking/core/constants/app_constants.dart';

class AppValidators {
  AppValidators._();

  // Student ID: 1-3 letters then 4-6 digits, e.g. Ae2596
  static String? validateStudentId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الطالب مطلوب.';
    }
    final trimmed = value.trim();
    if (!RegExp(AppConstants.studentIdPattern).hasMatch(trimmed)) {
      return 'صيغة غير صحيحة. مثال: Ae2596 (حرف أو حرفان ثم أرقام)';
    }
    return null;
  }

  static bool isValidStudentId(String value) =>
      validateStudentId(value) == null;

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الاسم مطلوب.';
    }
    if (value.trim().length < 3) {
      return 'الاسم يجب أن يكون 3 أحرف على الأقل.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب.';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'بريد إلكتروني غير صحيح.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة.';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل.';
    }
    return null;
  }

  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'هذا الحقل'} مطلوب.';
    }
    return null;
  }
}