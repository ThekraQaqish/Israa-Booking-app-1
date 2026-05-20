import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/reservation.dart';
import 'package:isra_fields_booking/domain/entities/sport.dart';
import 'package:isra_fields_booking/domain/entities/time_slot.dart';

class ReservationModel extends Reservation {
  const ReservationModel({
    required super.id,
    required super.studentId,
    required super.sport,
    required super.court,
    required super.date,
    required super.timeSlot,
    required super.genderPeriod,
    required super.selectedPlayerFormat,
    required super.status,
    required super.createdAt,
  });

  factory ReservationModel.create({
    required String id,
    required String studentId,
    required Sport sport,
    required Court court,
    required DateTime date,
    required TimeSlot timeSlot,
    required GenderPeriod genderPeriod,
    required String selectedPlayerFormat,
  }) {
    return ReservationModel(
      id: id,
      studentId: studentId,
      sport: sport,
      court: court,
      date: date,
      timeSlot: timeSlot,
      genderPeriod: genderPeriod,
      selectedPlayerFormat: selectedPlayerFormat,
      status: ReservationStatus.confirmed,
      createdAt: DateTime.now(),
    );
  }

  ReservationModel copyWithStatus(ReservationStatus newStatus) {
    return ReservationModel(
      id: id,
      studentId: studentId,
      sport: sport,
      court: court,
      date: date,
      timeSlot: timeSlot,
      genderPeriod: genderPeriod,
      selectedPlayerFormat: selectedPlayerFormat,
      status: newStatus,
      createdAt: createdAt,
    );
  }
}