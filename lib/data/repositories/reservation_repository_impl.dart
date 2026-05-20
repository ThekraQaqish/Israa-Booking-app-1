import 'package:isra_fields_booking/core/errors/exceptions.dart';
import 'package:isra_fields_booking/core/errors/failures.dart';
import 'package:isra_fields_booking/core/utils/result.dart';
import 'package:isra_fields_booking/data/datasources/reservation_datasource.dart';
import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/reservation.dart';
import 'package:isra_fields_booking/domain/entities/time_slot.dart';
import 'package:isra_fields_booking/domain/repositories/reservation_repository.dart';
import 'package:isra_fields_booking/domain/repositories/sport_repository.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final ReservationDataSource _dataSource;
  final SportRepository _sportRepository;

  const ReservationRepositoryImpl(this._dataSource, this._sportRepository);

  @override
  Future<Result<Reservation>> createReservation({
    required String studentId,
    required String sportId,
    required String courtId,
    required DateTime date,
    required TimeSlot timeSlot,
    required GenderPeriod genderPeriod,
    required String selectedPlayerFormat,
  }) async {
    try {
      final sportResult = await _sportRepository.getSportById(sportId);
      final courtResult = await _sportRepository.getCourtById(courtId);

      if (sportResult is! Success || courtResult is! Success) {
        return FailureResult(NotFoundFailure());
      }

      final reservation = await _dataSource.createReservation(
        studentId: studentId,
        sport: (sportResult as Success).data,
        court: (courtResult as Success).data,
        date: date,
        timeSlot: timeSlot,
        genderPeriod: genderPeriod,
        selectedPlayerFormat: selectedPlayerFormat,
      );
      return Success(reservation);
    } on SlotUnavailableException catch (e) {
      return FailureResult(SlotUnavailableFailure(e.message));
    } on ReservationException catch (e) {
      return FailureResult(ReservationFailure(e.message));
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Reservation>>> getMyReservations(String studentId) async {
    try {
      final reservations = await _dataSource.getMyReservations(studentId);
      return Success(reservations);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> cancelReservation(String reservationId) async {
    try {
      await _dataSource.cancelReservation(reservationId);
      return Success<void>(null);
    } on ReservationException catch (e) {
      return FailureResult(ReservationFailure(e.message));
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }
}