import 'package:isra_fields_booking/core/utils/result.dart';
import 'package:isra_fields_booking/domain/entities/student.dart';

abstract class AuthRepository {
  Future<Result<Student>> loginWithStudentId(String studentId);
  Future<Result<void>> logout();
  Future<Result<Student?>> getCurrentStudent();
  Future<bool> isAuthenticated();
  Future<Result<Student>> register({
    required String studentId,
    required String name,
    required String email,
    required String department,
    required String year,
    required String password,
  });
}