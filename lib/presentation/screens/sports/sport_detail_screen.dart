import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isra_fields_booking/core/constants/route_constants.dart';
import 'package:isra_fields_booking/core/theme/app_colors.dart';
import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/sport.dart';
import 'package:isra_fields_booking/presentation/providers/sport_provider.dart';
import 'package:isra_fields_booking/presentation/widgets/image_carousel.dart';

class SportDetailScreen extends ConsumerWidget {
  final String sportId;
  const SportDetailScreen({super.key, required this.sportId});

  Color _hexToColor(String hex) {
    final c = hex.replaceAll('#', '');
    return Color(int.parse('FF$c', radix: 16));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sportAsync = ref.watch(sportByIdProvider(sportId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: sportAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (sport) {
          if (sport == null) {
            return const Center(child: Text('الرياضة غير موجودة'));
          }
          final color = _hexToColor(sport.colorHex);
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: color,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 18),
                  ),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: CourtImagePlaceholder(
                    color: color,
                    icon: IconData(sport.iconCodePoint, fontFamily: 'MaterialIcons'),
                    height: 220,
                    label: sport.nameAr,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sport.nameAr,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${sport.courts.length} ملعب متاح',
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 24),
                      const Text('اختر الملعب',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _CourtCard(
                      court: sport.courts[i],
                      sport: sport,
                      color: color,
                    ),
                    childCount: sport.courts.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CourtCard extends StatelessWidget {
  final Court court;
  final Sport sport;
  final Color color;

  const _CourtCard({
    required this.court,
    required this.sport,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: court.imageUrls.isEmpty
                ? CourtImagePlaceholder(
                    color: color,
                    icon: IconData(sport.iconCodePoint,
                        fontFamily: 'MaterialIcons'),
                    height: 150,
                  )
                : ImageCarousel(
                    imageUrls: court.imageUrls,
                    placeholderColor: color,
                    placeholderIcon: IconData(sport.iconCodePoint,
                        fontFamily: 'MaterialIcons'),
                    height: 150,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        court.number > 1
                            ? '${court.nameAr} رقم ${court.number}'
                            : court.nameAr,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: court.isAvailable
                            ? AppColors.successContainer
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle,
                              size: 7,
                              color: court.isAvailable
                                  ? AppColors.available
                                  : AppColors.unavailable),
                          const SizedBox(width: 4),
                          Text(
                            court.isAvailable ? 'متاح' : 'محجوز',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: court.isAvailable
                                    ? AppColors.available
                                    : AppColors.unavailable),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (court.type != CourtType.na)
                  Row(
                    children: [
                      Icon(
                        court.type == CourtType.indoor
                            ? Icons.roofing
                            : Icons.wb_sunny_outlined,
                        size: 15,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(court.typeAr,
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.textSecondary)),
                      const SizedBox(width: 16),
                    ],
                  ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: court.playerFormats
                      .map((f) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(f,
                                style: TextStyle(
                                    color: color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: court.isAvailable
                        ? () => context.push(
                            RouteConstants.bookingPath(sport.id, court.id))
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('احجز الآن',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}