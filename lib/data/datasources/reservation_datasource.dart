import 'package:isra_fields_booking/core/errors/exceptions.dart';
import 'package:isra_fields_booking/data/datasources/sport_datasource.dart';
import 'package:isra_fields_booking/data/models/reservation_model.dart';
import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/reservation.dart';
import 'package:isra_fields_booking/domain/entities/sport.dart';
import 'package:isra_fields_booking/domain/entities/time_slot.dart';

abstract class ReservationDataSource {
  Future<ReservationModel> createReservation({
    required String studentId,
    required Sport sport,
    required Court court,
    required DateTime date,
    required TimeSlot timeSlot,
    required GenderPeriod genderPeriod,
    required String selectedPlayerFormat,
  });

  Future<List<ReservationModel>> getMyReservations(String studentId);
  Future<void> cancelReservation(String reservationId);
}

class MockReservationDataSource implements ReservationDataSource {
  final MockSportDataSource _sportDataSource;

  MockReservationDataSource(this._sportDataSource);

  final List<ReservationModel> _reservations = [];
  int _idCounter = 1;

  @override
  Future<ReservationModel> createReservation({
    required String studentId,
    required Sport sport,
    required Court court,
    required DateTime date,
    required TimeSlot timeSlot,
    required GenderPeriod genderPeriod,
    required String selectedPlayerFormat,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final existing = _reservations.where((r) =>
        r.court.id == court.id &&
        r.date.year == date.year &&
        r.date.month == date.month &&
        r.date.day == date.day &&
        r.timeSlot.label == timeSlot.label &&
        r.status != ReservationStatus.cancelled);

    if (existing.isNotEmpty) {
      throw SlotUnavailableException('هذا الوقت محجوز بالفعل.');
    }

    final reservation = ReservationModel.create(
      id: 'RES${_idCounter.toString().padLeft(4, '0')}',
      studentId: studentId,
      sport: sport,
      court: court,
      date: date,
      timeSlot: timeSlot,
      genderPeriod: genderPeriod,
      selectedPlayerFormat: selectedPlayerFormat,
    );
    _idCounter++;
    _reservations.add(reservation);
    _sportDataSource.markSlotBooked(court.id, date, timeSlot.label);
    return reservation;
  }

  @override
  Future<List<ReservationModel>> getMyReservations(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _reservations
        .where((r) => r.studentId == studentId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> cancelReservation(String reservationId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index == -1) throw ReservationException('الحجز غير موجود.');
    _reservations[index] =
        _reservations[index].copyWithStatus(ReservationStatus.cancelled);
  }
}