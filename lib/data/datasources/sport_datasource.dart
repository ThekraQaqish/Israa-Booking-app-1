import 'package:flutter/material.dart';
import 'package:isra_fields_booking/core/constants/app_constants.dart';
import 'package:isra_fields_booking/data/models/court_model.dart';
import 'package:isra_fields_booking/data/models/sport_model.dart';
import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/time_slot.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HOW TO ADD COURT IMAGES:
// Each court has an `imageUrls` list. Add up to 3 real URLs per court.
// Example:
//   imageUrls: [
//     'https://your-server.com/images/football_indoor_1.jpg',
//     'https://your-server.com/images/football_indoor_2.jpg',
//     'https://your-server.com/images/football_indoor_3.jpg',
//   ],
// Replace the placeholder URLs below with your actual image links.
// ─────────────────────────────────────────────────────────────────────────────

abstract class SportDataSource {
  Future<List<SportModel>> getAllSports();
  Future<SportModel> getSportById(String sportId);
  Future<List<CourtModel>> getCourtsBySport(String sportId);
  Future<CourtModel> getCourtById(String courtId);
  Future<List<TimeSlot>> getAvailableSlots(String courtId, DateTime date);
}

class MockSportDataSource implements SportDataSource {
  static final List<SportModel> _sports = [
    // ── كرة السلة ─────────────────────────────────────────────────────────
    SportModel(
      id: 'basketball',
      nameAr: 'كرة السلة',
      iconCodePoint: Icons.sports_basketball.codePoint,
      colorHex: '#E65100',
      courts: [
        CourtModel(
          id: 'basketball_indoor',
          sportId: 'basketball',
          nameAr: 'الملعب الداخلي',
          type: CourtType.indoor,
          number: 1,
          playerFormats: ['5 ضد 5'],
          imageUrls: [
            // أضف روابط صورك هنا — مثال:
            // 'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=800',
          ],
        ),
        CourtModel(
          id: 'basketball_outdoor',
          sportId: 'basketball',
          nameAr: 'الملعب الخارجي',
          type: CourtType.outdoor,
          number: 1,
          playerFormats: ['5 ضد 5'],
          imageUrls: [
            // أضف روابط صورك هنا
          ],
        ),
      ],
    ),

    // ── كرة القدم ─────────────────────────────────────────────────────────
    SportModel(
      id: 'football',
      nameAr: 'كرة القدم',
      iconCodePoint: Icons.sports_soccer.codePoint,
      colorHex: '#1B5E20',
      courts: [
        CourtModel(
          id: 'football_indoor',
          sportId: 'football',
          nameAr: 'الملعب الداخلي',
          type: CourtType.indoor,
          number: 1,
          playerFormats: ['5 ضد 5'],
          imageUrls: [
            // أضف روابط صورك هنا
          ],
        ),
        CourtModel(
          id: 'football_outdoor',
          sportId: 'football',
          nameAr: 'الملعب الخارجي',
          type: CourtType.outdoor,
          number: 1,
          playerFormats: ['5 ضد 5'],
          imageUrls: [
            // أضف روابط صورك هنا
          ],
        ),
      ],
    ),

    // ── ريشة الطائرة ──────────────────────────────────────────────────────
    SportModel(
      id: 'badminton',
      nameAr: 'ريشة الطائرة',
      iconCodePoint: Icons.sports_tennis.codePoint,
      colorHex: '#6A1B9A',
      courts: [
        CourtModel(
          id: 'badminton_1',
          sportId: 'badminton',
          nameAr: 'الملعب',
          type: CourtType.indoor,
          number: 1,
          playerFormats: ['1 ضد 1'],
          imageUrls: [
            // أضف روابط صورك هنا
          ],
        ),
      ],
    ),

    // ── بادل ──────────────────────────────────────────────────────────────
    SportModel(
      id: 'padel',
      nameAr: 'بادل',
      iconCodePoint: Icons.sports_tennis.codePoint,
      colorHex: '#0D47A1',
      courts: [
        CourtModel(
          id: 'padel_1',
          sportId: 'padel',
          nameAr: 'ملعب',
          type: CourtType.na,
          number: 1,
          playerFormats: ['1 ضد 1', '2 ضد 2', '3 ضد 3'],
          imageUrls: [],
        ),
        CourtModel(
          id: 'padel_2',
          sportId: 'padel',
          nameAr: 'ملعب',
          type: CourtType.na,
          number: 2,
          playerFormats: ['1 ضد 1', '2 ضد 2', '3 ضد 3'],
          imageUrls: [],
        ),
        CourtModel(
          id: 'padel_3',
          sportId: 'padel',
          nameAr: 'ملعب',
          type: CourtType.na,
          number: 3,
          playerFormats: ['1 ضد 1', '2 ضد 2', '3 ضد 3'],
          imageUrls: [],
        ),
      ],
    ),

    // ── كرة القدم الشاطئية ────────────────────────────────────────────────
    SportModel(
      id: 'beach_soccer',
      nameAr: 'كرة القدم الشاطئية',
      iconCodePoint: Icons.sports_soccer.codePoint,
      colorHex: '#BF8040',
      courts: [
        CourtModel(
          id: 'beach_soccer_1',
          sportId: 'beach_soccer',
          nameAr: 'الملعب الشاطئي',
          type: CourtType.outdoor,
          number: 1,
          playerFormats: ['5 ضد 5'],
          imageUrls: [],
        ),
      ],
    ),

    // ── الكرة الطائرة ─────────────────────────────────────────────────────
    SportModel(
      id: 'volleyball',
      nameAr: 'الكرة الطائرة',
      iconCodePoint: Icons.sports_volleyball.codePoint,
      colorHex: '#C62828',
      courts: [
        CourtModel(
          id: 'volleyball_indoor',
          sportId: 'volleyball',
          nameAr: 'الملعب الداخلي',
          type: CourtType.indoor,
          number: 1,
          playerFormats: ['6 ضد 6'],
          imageUrls: [],
        ),
        CourtModel(
          id: 'volleyball_outdoor',
          sportId: 'volleyball',
          nameAr: 'الملعب الخارجي',
          type: CourtType.outdoor,
          number: 1,
          playerFormats: ['3 ضد 3'],
          imageUrls: [],
        ),
      ],
    ),

    // ── تنس الطاولة ───────────────────────────────────────────────────────
    SportModel(
      id: 'table_tennis',
      nameAr: 'تنس الطاولة',
      iconCodePoint: Icons.sports_tennis.codePoint,
      colorHex: '#00695C',
      courts: [
        CourtModel(
          id: 'tt_1',
          sportId: 'table_tennis',
          nameAr: 'طاولة',
          type: CourtType.na,
          number: 1,
          playerFormats: ['1 ضد 1', '2 ضد 2'],
          imageUrls: [],
        ),
        CourtModel(
          id: 'tt_2',
          sportId: 'table_tennis',
          nameAr: 'طاولة',
          type: CourtType.na,
          number: 2,
          playerFormats: ['1 ضد 1', '2 ضد 2'],
          imageUrls: [],
        ),
        CourtModel(
          id: 'tt_3',
          sportId: 'table_tennis',
          nameAr: 'طاولة',
          type: CourtType.na,
          number: 3,
          playerFormats: ['1 ضد 1', '2 ضد 2'],
          imageUrls: [],
        ),
      ],
    ),

    // ── الإسكواش ──────────────────────────────────────────────────────────
    SportModel(
      id: 'squash',
      nameAr: 'الإسكواش',
      iconCodePoint: Icons.sports_tennis.codePoint,
      colorHex: '#BF360C',
      courts: [
        CourtModel(
          id: 'squash_1',
          sportId: 'squash',
          nameAr: 'ملعب',
          type: CourtType.indoor,
          number: 1,
          playerFormats: ['1 ضد 1'],
          imageUrls: [],
        ),
        CourtModel(
          id: 'squash_2',
          sportId: 'squash',
          nameAr: 'ملعب',
          type: CourtType.indoor,
          number: 2,
          playerFormats: ['1 ضد 1'],
          imageUrls: [],
        ),
      ],
    ),
  ];

  static final Map<String, List<String>> _bookedSlots = {};

  @override
  Future<List<SportModel>> getAllSports() async {
    await Future.delayed(AppConstants.mockDelay);
    return _sports;
  }

  @override
  Future<SportModel> getSportById(String sportId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _sports.firstWhere(
      (s) => s.id == sportId,
      orElse: () => throw Exception('Sport not found: $sportId'),
    );
  }

  @override
  Future<List<CourtModel>> getCourtsBySport(String sportId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final sport = _sports.firstWhere(
      (s) => s.id == sportId,
      orElse: () => throw Exception('Sport not found: $sportId'),
    );
    return sport.courts.cast<CourtModel>();
  }

  @override
  Future<CourtModel> getCourtById(String courtId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    for (final sport in _sports) {
      for (final court in sport.courts) {
        if (court.id == courtId) return court as CourtModel;
      }
    }
    throw Exception('Court not found: $courtId');
  }

  @override
  Future<List<TimeSlot>> getAvailableSlots(
      String courtId, DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final key = '$courtId-${date.year}-${date.month}-${date.day}';
    final booked = _bookedSlots[key] ?? [];
    return AppConstants.timeSlots.asMap().entries.map((entry) {
      final label = entry.value;
      final isAvail = !booked.contains(label) &&
          !AppConstants.mockedBookedSlots.containsKey(label);
      return TimeSlot(
          id: '${key}_${entry.key}', label: label, isAvailable: isAvail);
    }).toList();
  }

  void markSlotBooked(String courtId, DateTime date, String slotLabel) {
    final key = '$courtId-${date.year}-${date.month}-${date.day}';
    _bookedSlots.putIfAbsent(key, () => []).add(slotLabel);
  }
}