import 'package:isra_fields_booking/core/errors/failures.dart';
import 'package:isra_fields_booking/core/utils/result.dart';
import 'package:isra_fields_booking/data/datasources/sport_datasource.dart';
import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/sport.dart';
import 'package:isra_fields_booking/domain/entities/time_slot.dart';
import 'package:isra_fields_booking/domain/repositories/sport_repository.dart';

class SportRepositoryImpl implements SportRepository {
  final SportDataSource _dataSource;
  const SportRepositoryImpl(this._dataSource);

  @override
  Future<Result<List<Sport>>> getAllSports() async {
    try {
      final sports = await _dataSource.getAllSports();
      return Success(sports);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Sport>> getSportById(String sportId) async {
    try {
      final sport = await _dataSource.getSportById(sportId);
      return Success(sport);
    } catch (e) {
      return FailureResult(NotFoundFailure());
    }
  }

  @override
  Future<Result<List<Court>>> getCourtsBySport(String sportId) async {
    try {
      final courts = await _dataSource.getCourtsBySport(sportId);
      return Success(courts);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Court>> getCourtById(String courtId) async {
    try {
      final court = await _dataSource.getCourtById(courtId);
      return Success(court);
    } catch (e) {
      return FailureResult(NotFoundFailure());
    }
  }

  @override
  Future<Result<List<TimeSlot>>> getAvailableSlots(String courtId, DateTime date) async {
    try {
      final slots = await _dataSource.getAvailableSlots(courtId, date);
      return Success(slots);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }
}