import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String studentId;
  final String name;
  final String email;
  final String department;
  final String year;
  final bool isActive;

  const Student({
    required this.studentId,
    required this.name,
    required this.email,
    required this.department,
    required this.year,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [studentId, name, email, department, year, isActive];

  Student copyWith({
    String? studentId, String? name, String? email,
    String? department, String? year, bool? isActive,
  }) {
    return Student(
      studentId: studentId ?? this.studentId,
      name: name ?? this.name,
      email: email ?? this.email,
      department: department ?? this.department,
      year: year ?? this.year,
      isActive: isActive ?? this.isActive,
    );
  }
}