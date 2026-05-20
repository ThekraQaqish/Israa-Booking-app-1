import 'package:isra_fields_booking/domain/entities/court.dart';

class CourtModel extends Court {
  const CourtModel({
    required super.id,
    required super.sportId,
    required super.nameAr,
    required super.type,
    required super.number,
    required super.playerFormats,
    super.imageUrls,
    super.isAvailable,
  });

  factory CourtModel.fromJson(Map<String, dynamic> json) {
    return CourtModel(
      id: json['id'] as String,
      sportId: json['sport_id'] as String,
      nameAr: json['name_ar'] as String,
      type: CourtType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => CourtType.na,
      ),
      number: json['number'] as int,
      playerFormats: List<String>.from(json['player_formats'] as List),
      imageUrls: List<String>.from(json['image_urls'] as List? ?? []),
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sport_id': sportId,
        'name_ar': nameAr,
        'type': type.name,
        'number': number,
        'player_formats': playerFormats,
        'image_urls': imageUrls,
        'is_available': isAvailable,
      };
}