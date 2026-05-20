import 'package:isra_fields_booking/core/constants/app_constants.dart';
import 'package:isra_fields_booking/core/errors/exceptions.dart';
import 'package:isra_fields_booking/data/models/student_model.dart';

abstract class AuthRemoteDataSource {
  Future<StudentModel> loginWithStudentId(String studentId);

  Future<StudentModel> register({
    required String studentId,
    required String name,
    required String email,
    required String department,
    required String year,
    required String password,
  });

  Future<void> logout();
  Future<StudentModel?> getCurrentStudent();
}

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  StudentModel? _sessionStudent;

  // In-memory "database" — starts with demo accounts
  final Map<String, Map<String, dynamic>> _db = {
    'Ae2596': {
      'student_id': 'Ae2596',
      'name': 'أحمد الخالدي',
      'email': 'Ae2596@isra.edu.jo',
      'department': 'علوم الحاسوب',
      'year': 'السنة الرابعة',
      'password': '123456',
      'is_active': true,
    },
    'Bs1234': {
      'student_id': 'Bs1234',
      'name': 'سارة المنصوري',
      'email': 'Bs1234@isra.edu.jo',
      'department': 'هندسة البرمجيات',
      'year': 'السنة الثالثة',
      'password': '123456',
      'is_active': true,
    },
    'Cm9876': {
      'student_id': 'Cm9876',
      'name': 'عمر الراشد',
      'email': 'Cm9876@isra.edu.jo',
      'department': 'الهندسة المدنية',
      'year': 'السنة الثانية',
      'password': '123456',
      'is_active': true,
    },
    'Dr4521': {
      'student_id': 'Dr4521',
      'name': 'لينا البركات',
      'email': 'Dr4521@isra.edu.jo',
      'department': 'إدارة الأعمال',
      'year': 'السنة الأولى',
      'password': '123456',
      'is_active': true,
    },
    'Ez3210': {
      'student_id': 'Ez3210',
      'name': 'خالد الناصر',
      'email': 'Ez3210@isra.edu.jo',
      'department': 'الصيدلة',
      'year': 'السنة الخامسة',
      'password': '123456',
      'is_active': false, // suspended — for testing error state
    },
  };

  @override
  Future<StudentModel> loginWithStudentId(String studentId) async {
    await Future.delayed(AppConstants.mockAuthDelay);

    final data = _db[studentId.trim()];
    if (data == null) {
      throw const AuthException('رقم الطالب غير موجود. تحقق من الرقم أو سجّل حساباً جديداً.');
    }

    final student = StudentModel.fromJson(data);
    if (!student.isActive) {
      throw const AuthException('حسابك موقوف. تواصل مع إدارة الجامعة.');
    }

    _sessionStudent = student;
    return student;
  }

  @override
  Future<StudentModel> register({
    required String studentId,
    required String name,
    required String email,
    required String department,
    required String year,
    required String password,
  }) async {
    await Future.delayed(AppConstants.mockAuthDelay);

    final id = studentId.trim();

    if (_db.containsKey(id)) {
      throw const AuthException('رقم الطالب مسجّل بالفعل. حاول تسجيل الدخول.');
    }

    final newStudent = {
      'student_id': id,
      'name': name.trim(),
      'email': email.trim().isEmpty ? '$id@isra.edu.jo' : email.trim(),
      'department': department,
      'year': year,
      'password': password,
      'is_active': true,
    };

    _db[id] = newStudent;

    final student = StudentModel.fromJson(newStudent);
    _sessionStudent = student;
    return student;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _sessionStudent = null;
  }

  @override
  Future<StudentModel?> getCurrentStudent() async {
    return _sessionStudent;
  }
}