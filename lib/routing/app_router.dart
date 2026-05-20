import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isra_fields_booking/core/constants/route_constants.dart';
import 'package:isra_fields_booking/presentation/providers/auth_provider.dart';
import 'package:isra_fields_booking/presentation/providers/auth_state.dart';
import 'package:isra_fields_booking/presentation/screens/booking/booking_screen.dart';
import 'package:isra_fields_booking/presentation/screens/booking/booking_success_screen.dart';
import 'package:isra_fields_booking/presentation/screens/login/login_screen.dart';
import 'package:isra_fields_booking/presentation/screens/login/register_screen.dart';
import 'package:isra_fields_booking/presentation/screens/main/main_shell.dart';
import 'package:isra_fields_booking/presentation/screens/splash/splash_screen.dart';
import 'package:isra_fields_booking/presentation/screens/sports/sport_detail_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: RouteConstants.splash,
    refreshListenable: notifier,
    debugLogDiagnostics: false,
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(authProvider);
      final loc = state.matchedLocation;
      final isOnSplash = loc == RouteConstants.splash;
      final isOnLogin = loc == RouteConstants.login;
      final isOnRegister = loc == RouteConstants.register;
      final isAuthenticated = authState is AuthAuthenticated;

      if (isOnSplash) return null;
      if (!isAuthenticated && !isOnLogin && !isOnRegister) return RouteConstants.login;
      if (isAuthenticated && (isOnLogin || isOnRegister)) return RouteConstants.home;
      return null;
    },
    routes: [
      GoRoute(
        path: RouteConstants.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteConstants.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteConstants.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteConstants.home,
        builder: (_, __) => const MainShell(),
        routes: [
          GoRoute(
            path: 'sport/:sportId',
            builder: (_, state) => SportDetailScreen(
              sportId: state.pathParameters['sportId']!,
            ),
            routes: [
              GoRoute(
                path: 'court/:courtId/book',
                builder: (_, state) => BookingScreen(
                  sportId: state.pathParameters['sportId']!,
                  courtId: state.pathParameters['courtId']!,
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteConstants.bookingSuccess,
        builder: (_, __) => const BookingSuccessScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('الصفحة غير موجودة'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteConstants.home),
              child: const Text('الرئيسية'),
            ),
          ],
        ),
      ),
    ),
  );
});

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}