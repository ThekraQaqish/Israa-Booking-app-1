import 'package:isra_fields_booking/core/utils/result.dart';
import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/reservation.dart';
import 'package:isra_fields_booking/domain/entities/time_slot.dart';
import 'package:isra_fields_booking/domain/repositories/reservation_repository.dart';

class CreateReservationUseCase {
  final ReservationRepository _repository;
  const CreateReservationUseCase(this._repository);

  Future<Result<Reservation>> call({
    required String studentId,
    required String sportId,
    required String courtId,
    required DateTime date,
    required TimeSlot timeSlot,
    required GenderPeriod genderPeriod,
    required String selectedPlayerFormat,
  }) {
    return _repository.createReservation(
      studentId: studentId,
      sportId: sportId,
      courtId: courtId,
      date: date,
      timeSlot: timeSlot,
      genderPeriod: genderPeriod,
      selectedPlayerFormat: selectedPlayerFormat,
    );
  }
}

class GetMyReservationsUseCase {
  final ReservationRepository _repository;
  const GetMyReservationsUseCase(this._repository);
  Future<Result<List<Reservation>>> call(String studentId) =>
      _repository.getMyReservations(studentId);
}

class CancelReservationUseCase {
  final ReservationRepository _repository;
  const CancelReservationUseCase(this._repository);
  Future<Result<void>> call(String reservationId) =>
      _repository.cancelReservation(reservationId);
}