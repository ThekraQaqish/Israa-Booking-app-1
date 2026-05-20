import 'package:isra_fields_booking/domain/entities/student.dart';

class StudentModel extends Student {
  const StudentModel({
    required super.studentId,
    required super.name,
    required super.email,
    required super.department,
    required super.year,
    super.isActive,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentId: json['student_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      department: json['department'] as String,
      year: json['year'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'name': name,
        'email': email,
        'department': department,
        'year': year,
        'is_active': isActive,
      };
}