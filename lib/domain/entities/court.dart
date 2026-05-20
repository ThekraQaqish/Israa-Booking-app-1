import 'package:equatable/equatable.dart';

enum CourtType { indoor, outdoor, na }

enum GenderPeriod { male, female }

class Court extends Equatable {
  final String id;
  final String sportId;
  final String nameAr;
  final CourtType type;
  final int number;
  final List<String> playerFormats;
  final List<String> imageUrls;
  final bool isAvailable;

  const Court({
    required this.id,
    required this.sportId,
    required this.nameAr,
    required this.type,
    required this.number,
    required this.playerFormats,
    this.imageUrls = const [],
    this.isAvailable = true,
  });

  String get typeAr {
    switch (type) {
      case CourtType.indoor:
        return 'داخلي';
      case CourtType.outdoor:
        return 'خارجي';
      case CourtType.na:
        return '';
    }
  }

  String get displayName {
    if (type == CourtType.na) return nameAr;
    return '$nameAr ${number > 1 ? 'رقم $number' : ''}';
  }

  @override
  List<Object?> get props => [id, sportId, nameAr, type, number, playerFormats, imageUrls, isAvailable];
}