import 'package:isra_fields_booking/core/utils/result.dart';
import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/reservation.dart';
import 'package:isra_fields_booking/domain/entities/time_slot.dart';

abstract class ReservationRepository {
  Future<Result<Reservation>> createReservation({
    required String studentId,
    required String sportId,
    required String courtId,
    required DateTime date,
    required TimeSlot timeSlot,
    required GenderPeriod genderPeriod,
    required String selectedPlayerFormat,
  });

  Future<Result<List<Reservation>>> getMyReservations(String studentId);
  Future<Result<void>> cancelReservation(String reservationId);
}