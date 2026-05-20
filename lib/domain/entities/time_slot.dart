import 'package:equatable/equatable.dart';

class TimeSlot extends Equatable {
  final String id;
  final String label;
  final bool isAvailable;

  const TimeSlot({
    required this.id,
    required this.label,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [id, label, isAvailable];
}