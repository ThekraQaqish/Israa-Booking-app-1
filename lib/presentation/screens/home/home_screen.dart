import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isra_fields_booking/core/constants/app_constants.dart';
import 'package:isra_fields_booking/core/constants/route_constants.dart';
import 'package:isra_fields_booking/core/theme/app_colors.dart';
import 'package:isra_fields_booking/domain/entities/sport.dart';
import 'package:isra_fields_booking/presentation/providers/auth_provider.dart';
import 'package:isra_fields_booking/presentation/providers/auth_state.dart';
import 'package:isra_fields_booking/presentation/providers/reservation_provider.dart';
import 'package:isra_fields_booking/presentation/providers/sport_provider.dart';
import 'package:isra_fields_booking/presentation/widgets/reservation_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Color _hexToColor(String hex) {
    final c = hex.replaceAll('#', '');
    return Color(int.parse('FF$c', radix: 16));
  }

  String _getGreeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'صباح الخير 👋';
    if (h < 17) return 'مساء الخير 👋';
    return 'مساء النور 👋';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final student = auth is AuthAuthenticated ? auth.student : null;
    final sportsAsync = ref.watch(allSportsProvider);
    final reservationsAsync = ref.watch(myReservationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(context, student?.name ?? 'طالب'),
          ),
          SliverToBoxAdapter(
            child: sportsAsync.when(
              data: (sports) => _buildSportsSection(context, sports),
              loading: () => const SizedBox(
                height: 110,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
          // Quick Actions
          SliverToBoxAdapter(child: _buildQuickActions(context)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الحجوزات القادمة',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'عرض الكل',
                      style: TextStyle(color: AppColors.primary, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: reservationsAsync.when(
              data: (list) {
                final upcoming =
                    list.where((r) => r.isUpcoming).take(3).toList();
                if (upcoming.isEmpty) return _buildEmptyBookings(context);
                return Column(
                  children: upcoming
                      .map((r) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 6),
                            child: ReservationCard(reservation: r),
                          ))
                      .toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child:
                      CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // لوغو الجامعة — المسار الصحيح
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/IsraaLogo.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(
                              child: Text(
                                'IU',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.circle,
                                color: Color(0xFF4CAF50), size: 8),
                            SizedBox(width: 6),
                            Text(
                              'الملاعب متاحة',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _getGreeting(),
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            // Arc فاصل أبيض بأسفل الهيدر
            Container(
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSportsSection(BuildContext context, List<Sport> sports) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 4, 20, 14),
            child: Text(
              'الرياضات المتاحة',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: sports.length,
              itemBuilder: (context, i) {
                final sport = sports[i];
                final color = _hexToColor(sport.colorHex);
                return GestureDetector(
                  onTap: () => context
                      .push(RouteConstants.sportDetailPath(sport.id)),
                  child: Container(
                    width: 76,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: color.withOpacity(0.2), width: 1),
                          ),
                          child: Icon(
                            IconData(sport.iconCodePoint,
                                fontFamily: 'MaterialIcons'),
                            color: color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          sport.nameAr,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Row(
        children: [
          Expanded(
            child: _QuickCard(
              icon: Icons.sports_soccer_outlined,
              title: 'احجز ملعب',
              subtitle: 'تصفح الملاعب المتاحة',
              color: AppColors.primary,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickCard(
              icon: Icons.calendar_month_outlined,
              title: 'حجوزاتي',
              subtitle: 'عرض كل حجوزاتك',
              color: const Color(0xFF1565C0),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBookings(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.calendar_month_outlined,
                  color: AppColors.primary, size: 36),
            ),
            const SizedBox(height: 14),
            const Text(
              'لا توجد حجوزات قادمة',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'احجز ملعبك المفضل الآن',
              style:
                  TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(title,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 3),
            Text(subtitle,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}