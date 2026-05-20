import 'package:equatable/equatable.dart';
import 'package:isra_fields_booking/domain/entities/student.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  final Student student;
  const AuthAuthenticated(this.student);
  @override
  List<Object?> get props => [student];
}

final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}