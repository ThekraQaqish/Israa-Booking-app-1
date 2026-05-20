import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isra_fields_booking/core/theme/app_colors.dart';
import 'package:isra_fields_booking/domain/entities/reservation.dart';
import 'package:isra_fields_booking/presentation/providers/reservation_provider.dart';
import 'package:isra_fields_booking/presentation/widgets/reservation_card.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _cancel(String reservationId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إلغاء الحجز'),
        content: const Text('هل أنت متأكد من إلغاء هذا الحجز؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('لا')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('نعم، إلغاء',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref
        .read(cancelReservationUseCaseProvider)
        .call(reservationId);
    ref.invalidate(myReservationsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final reservationsAsync = ref.watch(myReservationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('حجوزاتي',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabs,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: AppColors.secondary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'القادمة'),
            Tab(text: 'السابقة'),
          ],
        ),
      ),
      body: reservationsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(
            child: Text('حدث خطأ: $e',
                style: const TextStyle(color: AppColors.error))),
        data: (all) {
          final upcoming = all.where((r) => r.isUpcoming).toList();
          final past = all.where((r) => !r.isUpcoming).toList();
          return TabBarView(
            controller: _tabs,
            children: [
              _buildList(upcoming, canCancel: true),
              _buildList(past, canCancel: false),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(List<Reservation> list, {required bool canCancel}) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.calendar_month_outlined,
                  color: AppColors.primary, size: 40),
            ),
            const SizedBox(height: 16),
            const Text('لا توجد حجوزات',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(myReservationsProvider),
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, i) {
          final r = list[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ReservationCard(
              reservation: r,
              onCancel: canCancel && r.status == ReservationStatus.confirmed
                  ? () => _cancel(r.id)
                  : null,
            ),
          );
        },
      ),
    );
  }
}