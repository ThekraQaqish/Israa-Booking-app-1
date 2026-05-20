import 'package:equatable/equatable.dart';
import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/sport.dart';
import 'package:isra_fields_booking/domain/entities/time_slot.dart';

enum ReservationStatus { pending, confirmed, cancelled, completed }

class Reservation extends Equatable {
  final String id;
  final String studentId;
  final Sport sport;
  final Court court;
  final DateTime date;
  final TimeSlot timeSlot;
  final GenderPeriod genderPeriod;
  final String selectedPlayerFormat;
  final ReservationStatus status;
  final DateTime createdAt;

  const Reservation({
    required this.id,
    required this.studentId,
    required this.sport,
    required this.court,
    required this.date,
    required this.timeSlot,
    required this.genderPeriod,
    required this.selectedPlayerFormat,
    required this.status,
    required this.createdAt,
  });

  String get statusAr {
    switch (status) {
      case ReservationStatus.pending:
        return 'قيد الانتظار';
      case ReservationStatus.confirmed:
        return 'مؤكد';
      case ReservationStatus.cancelled:
        return 'ملغي';
      case ReservationStatus.completed:
        return 'منتهي';
    }
  }

  String get genderAr =>
      genderPeriod == GenderPeriod.male ? 'رجال' : 'نساء';

  bool get isUpcoming =>
      status != ReservationStatus.cancelled &&
      status != ReservationStatus.completed &&
      date.isAfter(DateTime.now().subtract(const Duration(hours: 1)));

  @override
  List<Object?> get props => [id, studentId, sport, court, date, timeSlot, genderPeriod, selectedPlayerFormat, status, createdAt];
}