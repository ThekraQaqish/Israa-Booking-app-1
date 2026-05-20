class AppConstants {
  AppConstants._();

  static const String appName = 'حجوزات جامعة الإسراء';
  static const String universityName = 'جامعة الإسراء';
  static const String logoPath = 'assets/images/IsraaLogo.png';

  // Student ID: 2 letters + 4 digits, e.g. Ae2596
  static const int studentIdMinLength = 6;
  static const int studentIdMaxLength = 8;
  static const String studentIdPattern = r'^[A-Za-z]{1,3}\d{4,6}$';
  static const String studentIdHint = 'مثال: Ae2596';

  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircular = 100.0;

  static const double buttonHeight = 52.0;
  static const double inputHeight = 56.0;
  static const double courtCardHeight = 200.0;
  static const double sportCardSize = 90.0;

  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 350);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration mockDelay = Duration(milliseconds: 800);
  static const Duration mockAuthDelay = Duration(milliseconds: 800);

  static const List<String> mockValidStudentIds = [
    'Ae2596',
    'Bs1234',
    'Cm9876',
    'Dr4521',
    'Ez3210',
  ];

  static const List<String> departments = [
    'علوم الحاسوب',
    'هندسة البرمجيات',
    'الهندسة المدنية',
    'الهندسة الكهربائية',
    'إدارة الأعمال',
    'المحاسبة',
    'الصيدلة',
    'الطب البشري',
    'القانون',
    'التمريض',
    'العلوم الإنسانية',
    'التربية',
    'الهندسة المعمارية',
    'تقنية المعلومات',
  ];

  static const List<String> studyYears = [
    'السنة الأولى',
    'السنة الثانية',
    'السنة الثالثة',
    'السنة الرابعة',
    'السنة الخامسة',
  ];

  static const List<String> timeSlots = [
    '08:00 - 09:00',
    '09:00 - 10:00',
    '10:00 - 11:00',
    '11:00 - 12:00',
    '12:00 - 13:00',
    '13:00 - 14:00',
    '14:00 - 15:00',
    '15:00 - 16:00',
    '16:00 - 17:00',
    '17:00 - 18:00',
    '18:00 - 19:00',
    '19:00 - 20:00',
    '20:00 - 21:00',
    '21:00 - 22:00',
  ];

  static const Map<String, int> mockedBookedSlots = {
    '09:00 - 10:00': 1,
    '12:00 - 13:00': 1,
    '17:00 - 18:00': 1,
    '20:00 - 21:00': 1,
  };
}