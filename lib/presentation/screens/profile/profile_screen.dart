import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isra_fields_booking/core/constants/app_constants.dart';
import 'package:isra_fields_booking/core/theme/app_colors.dart';
import 'package:isra_fields_booking/domain/entities/student.dart';
import 'package:isra_fields_booking/presentation/providers/auth_provider.dart';
import 'package:isra_fields_booking/presentation/providers/auth_state.dart';
import 'package:isra_fields_booking/presentation/providers/reservation_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final student = auth is AuthAuthenticated ? auth.student : null;
    final reservationsAsync = ref.watch(myReservationsProvider);

    final total = reservationsAsync.valueOrNull?.length ?? 0;
    final upcoming = reservationsAsync.valueOrNull?.where((r) => r.isUpcoming).length ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(student)),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildStats(total, upcoming, student),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('معلومات الحساب'),
                  const SizedBox(height: 12),
                  _InfoCard(items: [
                    _InfoRow(
                      icon: Icons.badge_outlined,
                      label: 'رقم الطالب',
                      value: student?.studentId ?? '-',
                    ),
                    _InfoRow(
                      icon: Icons.email_outlined,
                      label: 'البريد الإلكتروني',
                      value: student?.email ?? '-',
                    ),
                    _InfoRow(
                      icon: Icons.school_outlined,
                      label: 'التخصص',
                      value: student?.department ?? '-',
                    ),
                    _InfoRow(
                      icon: Icons.calendar_month_outlined,
                      label: 'السنة الدراسية',
                      value: student?.year ?? '-',
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _sectionTitle('جامعة الإسراء'),
                  const SizedBox(height: 12),
                  _InfoCard(items: [
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'الموقع',
                      value: 'عمان، الأردن',
                    ),
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      label: 'الهاتف',
                      value: '+962 6 4711710',
                    ),
                    _InfoRow(
                      icon: Icons.language_outlined,
                      label: 'الموقع الإلكتروني',
                      value: 'www.isra.edu.jo',
                    ),
                  ]),
                  const SizedBox(height: 32),
                  _buildLogoutButton(context, ref),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Student? student) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      AppConstants.logoPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                student?.name ?? 'طالب',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                student?.department ?? '',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  student?.year ?? '',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats(int total, int upcoming, Student? student) {
    final yearLabel = _extractYearLabel(student?.year ?? '');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(value: '$total', label: 'إجمالي الحجوزات'),
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          Expanded(
            child: _StatItem(value: '$upcoming', label: 'القادمة'),
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          Expanded(
            child: _StatItem(value: yearLabel, label: 'السنة'),
          ),
        ],
      ),
    );
  }

  String _extractYearLabel(String year) {
    if (year.isEmpty) return '-';
    final parts = year.split(' ');
    return parts.isNotEmpty ? parts.last : year;
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text('تسجيل الخروج',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('خروج',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
          if (confirmed == true) {
            ref.read(authProvider.notifier).logout();
          }
        },
        icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
        label: const Text(
          'تسجيل الخروج',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<_InfoRow> items;
  const _InfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final item = e.value;
          final isLast = e.key == items.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Icon(item.icon, size: 18, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Text(
                      item.label,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        item.value,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(height: 1, indent: 46, endIndent: 0),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _InfoRow {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});
}