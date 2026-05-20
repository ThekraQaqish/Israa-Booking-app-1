import 'package:isra_fields_booking/core/utils/result.dart';
import 'package:isra_fields_booking/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;
  const LogoutUseCase(this._authRepository);
  Future<Result<void>> call() => _authRepository.logout();
}