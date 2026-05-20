import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isra_fields_booking/core/constants/route_constants.dart';
import 'package:isra_fields_booking/core/theme/app_colors.dart';
import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/reservation.dart';
import 'package:isra_fields_booking/presentation/providers/reservation_provider.dart';

class BookingSuccessScreen extends ConsumerWidget {
  const BookingSuccessScreen({super.key});

  String _formatDate(DateTime date) {
    const days = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    const months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];
    return '$dayName، ${date.day} $monthName ${date.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final reservation = bookingState.valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildSuccessIcon(),
              const SizedBox(height: 24),
              const Text(
                'تم الحجز بنجاح! 🎉',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'تم تأكيد حجزك، نراك في الملعب!',
                style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (reservation != null) _buildReservationCard(reservation),
              const SizedBox(height: 28),
              _buildActions(context, ref),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: AppColors.successContainer,
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
        ),
        const Icon(
          Icons.check_circle_rounded,
          color: AppColors.success,
          size: 64,
        ),
      ],
    );
  }

  Widget _buildReservationCard(Reservation r) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.sports, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.sport.nameAr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        r.court.number > 1
                            ? '${r.court.nameAr} رقم ${r.court.number}'
                            : r.court.nameAr,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successContainer,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'مؤكد ✓',
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'التاريخ',
                  value: _formatDate(r.date),
                ),
                const Divider(height: 20),
                _DetailRow(
                  icon: Icons.access_time_outlined,
                  label: 'الوقت',
                  value: r.timeSlot.label,
                ),
                const Divider(height: 20),
                _DetailRow(
                  icon: r.genderPeriod == GenderPeriod.male
                      ? Icons.male
                      : Icons.female,
                  label: 'الفترة',
                  value: r.genderAr,
                  valueColor: r.genderPeriod == GenderPeriod.male
                      ? AppColors.male
                      : AppColors.female,
                ),
                const Divider(height: 20),
                _DetailRow(
                  icon: Icons.people_outline,
                  label: 'نوع اللعبة',
                  value: r.selectedPlayerFormat,
                ),
                if (r.court.type != CourtType.na) ...[
                  const Divider(height: 20),
                  _DetailRow(
                    icon: r.court.type == CourtType.indoor
                        ? Icons.roofing
                        : Icons.wb_sunny_outlined,
                    label: 'النوع',
                    value: r.court.typeAr,
                  ),
                ],
                const Divider(height: 20),
                _DetailRow(
                  icon: Icons.tag_rounded,
                  label: 'رقم الحجز',
                  value: r.id,
                  valueColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {
              ref.read(bookingProvider.notifier).reset();
              context.go(RouteConstants.home);
            },
            icon: const Icon(Icons.home_outlined, color: Colors.white),
            label: const Text(
              'العودة للرئيسية',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () {
              ref.read(bookingProvider.notifier).reset();
              context.go(RouteConstants.home);
            },
            icon: const Icon(Icons.calendar_month_outlined,
                color: AppColors.primary),
            label: const Text(
              'عرض حجوزاتي',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.primary),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}