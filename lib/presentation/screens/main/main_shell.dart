import 'package:flutter/material.dart';
import 'package:isra_fields_booking/core/theme/app_colors.dart';
import 'package:isra_fields_booking/presentation/screens/chatbot/chatbot_screen.dart';
import 'package:isra_fields_booking/presentation/screens/home/home_screen.dart';
import 'package:isra_fields_booking/presentation/screens/my_bookings/my_bookings_screen.dart';
import 'package:isra_fields_booking/presentation/screens/profile/profile_screen.dart';
import 'package:isra_fields_booking/presentation/screens/sports/sports_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    SportsScreen(),
    MyBookingsScreen(),
    ChatbotScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.navBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedItemColor: AppColors.navSelected,
            unselectedItemColor: AppColors.navUnselected,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.sports_outlined),
                activeIcon: Icon(Icons.sports),
                label: 'الملاعب',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                activeIcon: Icon(Icons.calendar_month),
                label: 'حجوزاتي',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.smart_toy_outlined),
                activeIcon: Icon(Icons.smart_toy),
                label: 'المساعد',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'حسابي',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
