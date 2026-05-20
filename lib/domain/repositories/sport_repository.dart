import 'package:isra_fields_booking/core/utils/result.dart';
import 'package:isra_fields_booking/domain/entities/sport.dart';
import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/time_slot.dart';

abstract class SportRepository {
  Future<Result<List<Sport>>> getAllSports();
  Future<Result<Sport>> getSportById(String sportId);
  Future<Result<List<Court>>> getCourtsBySport(String sportId);
  Future<Result<Court>> getCourtById(String courtId);
  Future<Result<List<TimeSlot>>> getAvailableSlots(String courtId, DateTime date);
}