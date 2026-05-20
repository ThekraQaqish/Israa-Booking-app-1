import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isra_fields_booking/data/datasources/auth_remote_datasource.dart';
import 'package:isra_fields_booking/data/repositories/auth_repository_impl.dart';
import 'package:isra_fields_booking/domain/entities/student.dart';
import 'package:isra_fields_booking/domain/repositories/auth_repository.dart';
import 'package:isra_fields_booking/domain/usecases/login_usecase.dart';
import 'package:isra_fields_booking/domain/usecases/logout_usecase.dart';
import 'package:isra_fields_booking/presentation/providers/auth_state.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return MockAuthRemoteDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    repository: ref.watch(authRepositoryProvider),
    loginUseCase: ref.watch(loginUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
  );
});

final currentStudentProvider = Provider<Student?>((ref) {
  final state = ref.watch(authProvider);
  if (state is AuthAuthenticated) return state.student;
  return null;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) is AuthAuthenticated;
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthNotifier({
    required AuthRepository repository,
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _repository = repository,
        _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        super(const AuthInitial());

  Future<void> login(String studentId) async {
    if (state is AuthLoading) return;
    state = const AuthLoading();
    final result = await _loginUseCase(studentId);
    result.when(
      onSuccess: (student) => state = AuthAuthenticated(student),
      onFailure: (failure) => state = AuthError(failure.message),
    );
  }

  Future<void> register({
    required String studentId,
    required String name,
    required String email,
    required String department,
    required String year,
    required String password,
  }) async {
    if (state is AuthLoading) return;
    state = const AuthLoading();
    final result = await _repository.register(
      studentId: studentId,
      name: name,
      email: email,
      department: department,
      year: year,
      password: password,
    );
    result.when(
      onSuccess: (student) => state = AuthAuthenticated(student),
      onFailure: (failure) => state = AuthError(failure.message),
    );
  }

  Future<void> logout() async {
    state = const AuthLoading();
    await _logoutUseCase();
    state = const AuthUnauthenticated();
  }

  void clearError() {
    if (state is AuthError) state = const AuthInitial();
  }
}