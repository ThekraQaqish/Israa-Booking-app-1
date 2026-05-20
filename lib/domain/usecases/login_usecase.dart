import 'package:isra_fields_booking/core/errors/failures.dart';
import 'package:isra_fields_booking/core/utils/result.dart';
import 'package:isra_fields_booking/core/utils/validators.dart';
import 'package:isra_fields_booking/domain/entities/student.dart';
import 'package:isra_fields_booking/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;
  const LoginUseCase(this._authRepository);

  Future<Result<Student>> call(String studentId) async {
    final error = AppValidators.validateStudentId(studentId);
    if (error != null) return FailureResult(ValidationFailure(error));
    return _authRepository.loginWithStudentId(studentId.trim());
  }
}