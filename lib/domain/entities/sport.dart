import 'package:equatable/equatable.dart';
import 'package:isra_fields_booking/domain/entities/court.dart';

class Sport extends Equatable {
  final String id;
  final String nameAr;
  final int iconCodePoint;
  final String colorHex;
  final List<Court> courts;

  const Sport({
    required this.id,
    required this.nameAr,
    required this.iconCodePoint,
    required this.colorHex,
    required this.courts,
  });

  @override
  List<Object?> get props => [id, nameAr, iconCodePoint, colorHex, courts];
}