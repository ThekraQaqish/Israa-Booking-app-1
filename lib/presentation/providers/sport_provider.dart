import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isra_fields_booking/data/datasources/sport_datasource.dart';
import 'package:isra_fields_booking/data/repositories/sport_repository_impl.dart';
import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/sport.dart';
import 'package:isra_fields_booking/domain/entities/time_slot.dart';
import 'package:isra_fields_booking/domain/repositories/sport_repository.dart';
import 'package:isra_fields_booking/domain/usecases/get_courts_usecase.dart';
import 'package:isra_fields_booking/domain/usecases/get_sports_usecase.dart';

final mockSportDataSourceProvider = Provider<MockSportDataSource>((ref) {
  return MockSportDataSource();
});

final sportDataSourceProvider = Provider<SportDataSource>((ref) {
  return ref.watch(mockSportDataSourceProvider);
});

final sportRepositoryProvider = Provider<SportRepository>((ref) {
  return SportRepositoryImpl(ref.watch(sportDataSourceProvider));
});

final getSportsUseCaseProvider = Provider<GetSportsUseCase>((ref) {
  return GetSportsUseCase(ref.watch(sportRepositoryProvider));
});

final getCourtsUseCaseProvider = Provider<GetCourtsUseCase>((ref) {
  return GetCourtsUseCase(ref.watch(sportRepositoryProvider));
});

final getAvailableSlotsUseCaseProvider = Provider<GetAvailableSlotsUseCase>((ref) {
  return GetAvailableSlotsUseCase(ref.watch(sportRepositoryProvider));
});

final allSportsProvider = FutureProvider<List<Sport>>((ref) async {
  final useCase = ref.watch(getSportsUseCaseProvider);
  final result = await useCase();
  return result.getOrNull() ?? [];
});

final sportByIdProvider = FutureProvider.family<Sport?, String>((ref, sportId) async {
  final repo = ref.watch(sportRepositoryProvider);
  final result = await repo.getSportById(sportId);
  return result.getOrNull();
});

final courtsBySporthProvider = FutureProvider.family<List<Court>, String>((ref, sportId) async {
  final useCase = ref.watch(getCourtsUseCaseProvider);
  final result = await useCase(sportId);
  return result.getOrNull() ?? [];
});

final availableSlotsProvider =
    FutureProvider.family<List<TimeSlot>, ({String courtId, DateTime date})>(
        (ref, args) async {
  final useCase = ref.watch(getAvailableSlotsUseCaseProvider);
  final result = await useCase(args.courtId, args.date);
  return result.getOrNull() ?? [];
});