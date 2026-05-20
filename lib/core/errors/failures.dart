import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => message;
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'فشل تسجيل الدخول. تحقق من رقم الطالب.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'لا يوجد اتصال بالإنترنت.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'خطأ في الخادم. حاول مرة أخرى.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'العنصر المطلوب غير موجود.']);
}

class ReservationFailure extends Failure {
  const ReservationFailure([super.message = 'فشل إتمام الحجز. حاول مرة أخرى.']);
}

class SlotUnavailableFailure extends Failure {
  const SlotUnavailableFailure([super.message = 'هذا الوقت محجوز بالفعل.']);
}

class DuplicateReservationFailure extends Failure {
  const DuplicateReservationFailure([super.message = 'لديك حجز نشط بالفعل.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'حدث خطأ غير متوقع.']);
}