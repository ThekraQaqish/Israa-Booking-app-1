import 'package:isra_fields_booking/core/errors/failures.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  void when({
    required void Function(T data) onSuccess,
    required void Function(Failure failure) onFailure,
  }) {
    if (this is Success<T>) {
      onSuccess((this as Success<T>).data);
    } else if (this is FailureResult<T>) {
      onFailure((this as FailureResult<T>).failure);
    }
  }

  T? getOrNull() {
    if (this is Success<T>) return (this as Success<T>).data;
    return null;
  }

  Failure? failureOrNull() {
    if (this is FailureResult<T>) return (this as FailureResult<T>).failure;
    return null;
  }
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class FailureResult<T> extends Result<T> {
  final Failure failure;
  const FailureResult(this.failure);
}