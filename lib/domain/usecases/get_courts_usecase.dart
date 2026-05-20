import 'package:isra_fields_booking/core/utils/result.dart';
import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/time_slot.dart';
import 'package:isra_fields_booking/domain/repositories/sport_repository.dart';

class GetCourtsUseCase {
  final SportRepository _repository;
  const GetCourtsUseCase(this._repository);
  Future<Result<List<Court>>> call(String sportId) =>
      _repository.getCourtsBySport(sportId);
}

class GetAvailableSlotsUseCase {
  final SportRepository _repository;
  const GetAvailableSlotsUseCase(this._repository);
  Future<Result<List<TimeSlot>>> call(String courtId, DateTime date) =>
      _repository.getAvailableSlots(courtId, date);
}