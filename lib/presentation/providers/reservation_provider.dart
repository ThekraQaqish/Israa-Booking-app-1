import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isra_fields_booking/core/utils/result.dart';
import 'package:isra_fields_booking/data/datasources/reservation_datasource.dart';
import 'package:isra_fields_booking/data/repositories/reservation_repository_impl.dart';
import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/reservation.dart';
import 'package:isra_fields_booking/domain/entities/time_slot.dart';
import 'package:isra_fields_booking/domain/repositories/reservation_repository.dart';
import 'package:isra_fields_booking/domain/usecases/create_reservation_usecase.dart';
import 'package:isra_fields_booking/presentation/providers/auth_provider.dart';
import 'package:isra_fields_booking/presentation/providers/auth_state.dart';
import 'package:isra_fields_booking/presentation/providers/sport_provider.dart';

final reservationDataSourceProvider = Provider<MockReservationDataSource>((ref) {
  return MockReservationDataSource(ref.watch(mockSportDataSourceProvider));
});

final reservationRepositoryProvider = Provider<ReservationRepository>((ref) {
  return ReservationRepositoryImpl(
    ref.watch(reservationDataSourceProvider),
    ref.watch(sportRepositoryProvider),
  );
});

final createReservationUseCaseProvider = Provider<CreateReservationUseCase>((ref) {
  return CreateReservationUseCase(ref.watch(reservationRepositoryProvider));
});

final getMyReservationsUseCaseProvider = Provider<GetMyReservationsUseCase>((ref) {
  return GetMyReservationsUseCase(ref.watch(reservationRepositoryProvider));
});

final cancelReservationUseCaseProvider = Provider<CancelReservationUseCase>((ref) {
  return CancelReservationUseCase(ref.watch(reservationRepositoryProvider));
});

final myReservationsProvider = FutureProvider<List<Reservation>>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) return [];
  final useCase = ref.watch(getMyReservationsUseCaseProvider);
  final result = await useCase(authState.student.studentId);
  return result.getOrNull() ?? [];
});

class BookingNotifier extends StateNotifier<AsyncValue<Reservation?>> {
  final CreateReservationUseCase _createUseCase;
  final Ref _ref;

  BookingNotifier(this._createUseCase, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> createBooking({
    required String sportId,
    required String courtId,
    required DateTime date,
    required TimeSlot timeSlot,
    required GenderPeriod genderPeriod,
    required String selectedPlayerFormat,
  }) async {
    final authState = _ref.read(authProvider);
    if (authState is! AuthAuthenticated) return false;

    state = const AsyncValue.loading();

    final result = await _createUseCase(
      studentId: authState.student.studentId,
      sportId: sportId,
      courtId: courtId,
      date: date,
      timeSlot: timeSlot,
      genderPeriod: genderPeriod,
      selectedPlayerFormat: selectedPlayerFormat,
    );

    if (result is Success<Reservation>) {
      state = AsyncValue.data(result.data);
      _ref.invalidate(myReservationsProvider);
      return true;
    } else {
      state = AsyncValue.error(
        result.failureOrNull()?.message ?? 'حدث خطأ',
        StackTrace.current,
      );
      return false;
    }
  }

  void reset() => state = const AsyncValue.data(null);
}

final bookingProvider =
    StateNotifierProvider<BookingNotifier, AsyncValue<Reservation?>>((ref) {
  return BookingNotifier(
    ref.watch(createReservationUseCaseProvider),
    ref,
  );
});