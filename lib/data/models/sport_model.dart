import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/sport.dart';
import 'package:isra_fields_booking/data/models/court_model.dart';

class SportModel extends Sport {
  const SportModel({
    required super.id,
    required super.nameAr,
    required super.iconCodePoint,
    required super.colorHex,
    required super.courts,
  });

  factory SportModel.fromJson(Map<String, dynamic> json) {
    return SportModel(
      id: json['id'] as String,
      nameAr: json['name_ar'] as String,
      iconCodePoint: json['icon_code_point'] as int,
      colorHex: json['color_hex'] as String,
      courts: (json['courts'] as List<dynamic>)
          .map((c) => CourtModel.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}