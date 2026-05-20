import 'package:isra_fields_booking/core/errors/exceptions.dart';
import 'package:isra_fields_booking/core/errors/failures.dart';
import 'package:isra_fields_booking/core/utils/result.dart';
import 'package:isra_fields_booking/data/datasources/auth_remote_datasource.dart';
import 'package:isra_fields_booking/domain/entities/student.dart';
import 'package:isra_fields_booking/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  const AuthRepositoryImpl(this._dataSource);

  @override
  Future<Result<Student>> loginWithStudentId(String studentId) async {
    try {
      final student = await _dataSource.loginWithStudentId(studentId);
      return Success(student);
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return FailureResult(NetworkFailure(e.message));
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<Student>> register({
    required String studentId,
    required String name,
    required String email,
    required String department,
    required String year,
    required String password,
  }) async {
    try {
      final student = await _dataSource.register(
        studentId: studentId,
        name: name,
        email: email,
        department: department,
        year: year,
        password: password,
      );
      return Success(student);
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message));
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _dataSource.logout();
      return Success<void>(null);
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<Student?>> getCurrentStudent() async {
    try {
      final student = await _dataSource.getCurrentStudent();
      return Success(student);
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final result = await getCurrentStudent();
    if (result is Success<Student?>) return result.data != null;
    return false;
  }
}