import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:isra_fields_booking/core/constants/route_constants.dart';
import 'package:isra_fields_booking/core/theme/app_colors.dart';
import 'package:isra_fields_booking/domain/entities/court.dart';
import 'package:isra_fields_booking/domain/entities/time_slot.dart';
import 'package:isra_fields_booking/presentation/providers/reservation_provider.dart';
import 'package:isra_fields_booking/presentation/providers/sport_provider.dart';
import 'package:isra_fields_booking/presentation/widgets/image_carousel.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String sportId;
  final String courtId;

  const BookingScreen({
    super.key,
    required this.sportId,
    required this.courtId,
  });

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeSlot? _selectedSlot;
  GenderPeriod _selectedGender = GenderPeriod.male;
  String? _selectedFormat;

  Color _hexToColor(String hex) {
    final c = hex.replaceAll('#', '');
    return Color(int.parse('FF$c', radix: 16));
  }

  String _formatDay(DateTime day) {
    const days = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    return days[day.weekday - 1];
  }

  String _formatShortDay(DateTime day) {
    const days = ['إث', 'ثل', 'أر', 'خم', 'جم', 'سب', 'أح'];
    return days[day.weekday - 1];
  }

  Future<void> _confirmBooking(Court court) async {
    if (_selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار وقت للحجز'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    final format = _selectedFormat ?? court.playerFormats.first;
    final success = await ref.read(bookingProvider.notifier).createBooking(
          sportId: widget.sportId,
          courtId: widget.courtId,
          date: _selectedDate,
          timeSlot: _selectedSlot!,
          genderPeriod: _selectedGender,
          selectedPlayerFormat: format,
        );
    if (mounted) {
      if (success) {
        context.go(RouteConstants.bookingSuccess);
      } else {
        final state = ref.read(bookingProvider);
        final msg = state.error?.toString() ?? 'فشل الحجز، حاول مرة أخرى';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sportAsync = ref.watch(sportByIdProvider(widget.sportId));
    final bookingState = ref.watch(bookingProvider);
    final isLoading = bookingState is AsyncLoading;

    return sportAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('خطأ: $e'))),
      data: (sport) {
        if (sport == null) {
          return const Scaffold(body: Center(child: Text('الرياضة غير موجودة')));
        }

        final courtList = sport.courts.where((c) => c.id == widget.courtId).toList();
        if (courtList.isEmpty) {
          return const Scaffold(body: Center(child: Text('الملعب غير موجود')));
        }
        final court = courtList.first;
        final color = _hexToColor(sport.colorHex);

        _selectedFormat ??= court.playerFormats.first;

        final slotsAsync = ref.watch(availableSlotsProvider(
          (courtId: widget.courtId, date: _selectedDate),
        ));

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'احجز الآن',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => context.pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  child: court.imageUrls.isEmpty
                      ? CourtImagePlaceholder(
                          color: color,
                          icon: IconData(sport.iconCodePoint,
                              fontFamily: 'MaterialIcons'),
                          height: 180,
                          label: court.number > 1
                              ? '${court.nameAr} رقم ${court.number}'
                              : court.nameAr,
                        )
                      : ImageCarousel(
                          imageUrls: court.imageUrls,
                          placeholderColor: color,
                          placeholderIcon: IconData(sport.iconCodePoint,
                              fontFamily: 'MaterialIcons'),
                          height: 180,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CourtInfoRow(court: court, sport: sport, color: color),
                      const SizedBox(height: 24),

                      if (court.playerFormats.length > 1) ...[
                        _sectionHeader('نوع اللعبة', Icons.people_outline),
                        const SizedBox(height: 12),
                        _buildFormatSelector(court),
                        const SizedBox(height: 24),
                      ],

                      _sectionHeader('اختر التاريخ', Icons.calendar_today_outlined),
                      const SizedBox(height: 12),
                      _buildDatePicker(),
                      const SizedBox(height: 24),

                      _sectionHeader('اختر الوقت', Icons.access_time_outlined),
                      const SizedBox(height: 4),
                      _buildSlotsLegend(),
                      const SizedBox(height: 12),
                      slotsAsync.when(
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                        ),
                        error: (_, __) => const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('تعذر تحميل الأوقات المتاحة',
                              style: TextStyle(color: AppColors.error)),
                        ),
                        data: (slots) => _buildTimeSlots(slots),
                      ),
                      const SizedBox(height: 24),

                      _sectionHeader('الفترة', Icons.person_outline),
                      const SizedBox(height: 12),
                      _buildGenderSelector(),
                      const SizedBox(height: 28),

                      _buildSummaryCard(court, sport),
                      const SizedBox(height: 16),

                      _buildConfirmButton(isLoading, court),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSlotsLegend() {
    return Row(
      children: [
        _LegendDot(color: AppColors.slotSelected, label: 'محدد'),
        const SizedBox(width: 16),
        _LegendDot(color: AppColors.slotAvailable, label: 'متاح', bordered: true),
        const SizedBox(width: 16),
        _LegendDot(color: AppColors.slotBooked, label: 'محجوز', bordered: true, textColor: AppColors.textHint),
      ],
    );
  }

  Widget _buildFormatSelector(Court court) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: court.playerFormats.map((f) {
        final isSelected = _selectedFormat == f;
        return GestureDetector(
          onTap: () => setState(() => _selectedFormat = f),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.divider,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Text(
              f,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDatePicker() {
    final days = List.generate(14, (i) => DateTime.now().add(Duration(days: i)));
    return SizedBox(
      height: 76,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, i) {
          final day = days[i];
          final isSelected = DateUtils.isSameDay(day, _selectedDate);
          final isToday = i == 0;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = day;
                _selectedSlot = null;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 58,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : isToday
                          ? AppColors.accent.withOpacity(0.6)
                          : AppColors.divider,
                  width: isSelected || isToday ? 2 : 1,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatShortDay(day),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white70 : AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    day.day.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  if (isToday)
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white70 : AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlots(List<TimeSlot> slots) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.1,
      ),
      itemCount: slots.length,
      itemBuilder: (context, i) {
        final slot = slots[i];
        final isSelected = _selectedSlot?.id == slot.id;
        return GestureDetector(
          onTap: slot.isAvailable ? () => setState(() => _selectedSlot = slot) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: !slot.isAvailable
                  ? AppColors.slotBooked
                  : isSelected
                      ? AppColors.slotSelected
                      : AppColors.slotAvailable,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: !slot.isAvailable
                    ? AppColors.divider
                    : isSelected
                        ? AppColors.primary
                        : AppColors.accent.withOpacity(0.35),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              slot.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: !slot.isAvailable
                    ? AppColors.textHint
                    : isSelected
                        ? Colors.white
                        : AppColors.primary,
                decoration: !slot.isAvailable ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        Expanded(
          child: _GenderOption(
            icon: Icons.male,
            label: 'الفترة الرجالية',
            isSelected: _selectedGender == GenderPeriod.male,
            selectedColor: AppColors.male,
            selectedBg: AppColors.maleContainer,
            onTap: () => setState(() => _selectedGender = GenderPeriod.male),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _GenderOption(
            icon: Icons.female,
            label: 'الفترة النسائية',
            isSelected: _selectedGender == GenderPeriod.female,
            selectedColor: AppColors.female,
            selectedBg: AppColors.femaleContainer,
            onTap: () => setState(() => _selectedGender = GenderPeriod.female),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(Court court, dynamic sport) {
    if (_selectedSlot == null) return const SizedBox.shrink();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ملخص الحجز',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          _SummaryRow(
            label: 'التاريخ',
            value: '${_formatDay(_selectedDate)}، ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
          ),
          _SummaryRow(label: 'الوقت', value: _selectedSlot!.label),
          _SummaryRow(
            label: 'الفترة',
            value: _selectedGender == GenderPeriod.male ? 'رجال' : 'نساء',
          ),
          if (_selectedFormat != null)
            _SummaryRow(label: 'نوع اللعبة', value: _selectedFormat!),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(bool isLoading, Court court) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _confirmBooking(court),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 2,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'تأكيد الحجز',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _CourtInfoRow extends StatelessWidget {
  final Court court;
  final dynamic sport;
  final Color color;

  const _CourtInfoRow(
      {required this.court, required this.sport, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              IconData(sport.iconCodePoint, fontFamily: 'MaterialIcons'),
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  court.number > 1
                      ? '${court.nameAr} رقم ${court.number}'
                      : court.nameAr,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${sport.nameAr}${court.type != CourtType.na ? " · ${court.typeAr}" : ""}',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.successContainer,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 6, color: AppColors.available),
                SizedBox(width: 4),
                Text('متاح',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.available)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color selectedBg;
  final VoidCallback onTap;

  const _GenderOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.selectedBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? selectedColor : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? selectedColor : AppColors.textHint,
              size: 30,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: isSelected ? selectedColor : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool bordered;
  final Color? textColor;

  const _LegendDot({
    required this.color,
    required this.label,
    this.bordered = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: bordered ? Border.all(color: AppColors.divider) : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: textColor ?? AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}