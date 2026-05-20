import 'package:isra_fields_booking/core/utils/result.dart';
import 'package:isra_fields_booking/domain/entities/sport.dart';
import 'package:isra_fields_booking/domain/repositories/sport_repository.dart';

class GetSportsUseCase {
  final SportRepository _repository;
  const GetSportsUseCase(this._repository);
  Future<Result<List<Sport>>> call() => _repository.getAllSports();
}