import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isra_fields_booking/core/theme/app_colors.dart';
import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/reservation.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback? onCancel;

  const ReservationCard({
    super.key,
    required this.reservation,
    this.onCancel,
  });

  Color _statusColor() {
    switch (reservation.status) {
      case ReservationStatus.confirmed:
        return AppColors.success;
      case ReservationStatus.pending:
        return AppColors.warning;
      case ReservationStatus.cancelled:
        return AppColors.error;
      case ReservationStatus.completed:
        return AppColors.textHint;
    }
  }

  Color _statusBg() {
    switch (reservation.status) {
      case ReservationStatus.confirmed:
        return AppColors.successContainer;
      case ReservationStatus.pending:
        return AppColors.warningContainer;
      case ReservationStatus.cancelled:
        return AppColors.errorContainer;
      case ReservationStatus.completed:
        return AppColors.surfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = reservation;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.sport.nameAr,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
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
                  color: _statusBg(),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(r.statusAr,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _statusColor())),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                DateFormat('d MMMM yyyy', 'ar').format(r.date),
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time_outlined,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(r.timeSlot.label,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                r.genderPeriod == GenderPeriod.male ? Icons.male : Icons.female,
                size: 14,
                color: r.genderPeriod == GenderPeriod.male
                    ? AppColors.male
                    : AppColors.female,
              ),
              const SizedBox(width: 6),
              Text(r.genderAr,
                  style: TextStyle(
                      fontSize: 13,
                      color: r.genderPeriod == GenderPeriod.male
                          ? AppColors.male
                          : AppColors.female,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 16),
              const Icon(Icons.people_outline,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(r.selectedPlayerFormat,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
          if (onCancel != null &&
              r.status != ReservationStatus.cancelled &&
              r.status != ReservationStatus.completed) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('إلغاء الحجز',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}