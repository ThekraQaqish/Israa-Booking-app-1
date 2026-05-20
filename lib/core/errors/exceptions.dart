class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'فشل المصادقة.']);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'خطأ في الشبكة.']);

  @override
  String toString() => message;
}

class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'خطأ في الخادم.']);

  @override
  String toString() => message;
}

class ReservationException implements Exception {
  final String message;
  const ReservationException([this.message = 'فشل الحجز.']);

  @override
  String toString() => message;
}

class SlotUnavailableException implements Exception {
  final String message;
  const SlotUnavailableException([this.message = 'الوقت محجوز.']);

  @override
  String toString() => message;
}

class TimeoutException implements Exception {
  final String message;
  const TimeoutException([this.message = 'انتهت مهلة الطلب.']);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'خطأ في التخزين المؤقت.']);

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);

  @override
  String toString() => message;
}