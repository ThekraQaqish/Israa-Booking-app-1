import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isra_fields_booking/core/constants/route_constants.dart';
import 'package:isra_fields_booking/core/theme/app_colors.dart';
import 'package:isra_fields_booking/domain/entities/sport.dart';
import 'package:isra_fields_booking/presentation/providers/sport_provider.dart';

class SportsScreen extends ConsumerStatefulWidget {
  const SportsScreen({super.key});

  @override
  ConsumerState<SportsScreen> createState() => _SportsScreenState();
}

class _SportsScreenState extends ConsumerState<SportsScreen> {
  String? _selectedSportId;

  Color _hexToColor(String hex) {
    final c = hex.replaceAll('#', '');
    return Color(int.parse('FF$c', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final sportsAsync = ref.watch(allSportsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: sportsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(
            child: Text('حدث خطأ: $e',
                style: const TextStyle(color: AppColors.error))),
        data: (sports) {
          final selected = _selectedSportId == null
              ? sports
              : sports.where((s) => s.id == _selectedSportId).toList();

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.primary,
                pinned: true,
                expandedHeight: 120,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('الملاعب',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18)),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryDark, AppColors.primary],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildSportFilter(sports),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final sport = selected[i];
                      return _SportGroupCard(
                        sport: sport,
                        color: _hexToColor(sport.colorHex),
                        onCourtTap: (sportId) =>
                            context.push(RouteConstants.sportDetailPath(sportId)),
                      );
                    },
                    childCount: selected.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSportFilter(List<Sport> sports) {
    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: sports.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            final isAll = _selectedSportId == null;
            return GestureDetector(
              onTap: () => setState(() => _selectedSportId = null),
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isAll ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: isAll ? AppColors.primary : AppColors.divider),
                ),
                child: Center(
                  child: Text('الكل',
                      style: TextStyle(
                          color: isAll ? Colors.white : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ),
              ),
            );
          }
          final sport = sports[i - 1];
          final isSelected = _selectedSportId == sport.id;
          return GestureDetector(
            onTap: () => setState(() => _selectedSportId = sport.id),
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.divider),
              ),
              child: Center(
                child: Text(sport.nameAr,
                    style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SportGroupCard extends StatelessWidget {
  final Sport sport;
  final Color color;
  final void Function(String sportId) onCourtTap;

  const _SportGroupCard({
    required this.sport,
    required this.color,
    required this.onCourtTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCourtTap(sport.id),
      child: Container(
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
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      IconData(sport.iconCodePoint, fontFamily: 'MaterialIcons'),
                      size: 64,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                        ),
                      ),
                      child: Text(
                        sport.nameAr,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '${sport.courts.length} ملعب',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: sport.courts
                    .map((c) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: color.withOpacity(0.25)),
                          ),
                          child: Text(
                            c.playerFormats.first,
                            style: TextStyle(
                                color: color,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}