class RouteConstants {
  RouteConstants._();

  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String sportDetail = '/home/sport/:sportId';
  static const String booking = '/home/sport/:sportId/court/:courtId/book';
  static const String bookingSuccess = '/booking-success';
  static const String myBookings = '/my-bookings';
  static const String profile = '/profile';
  static const String register = '/register';


  static String sportDetailPath(String sportId) =>
      '/home/sport/$sportId';

  static String bookingPath(String sportId, String courtId) =>
      '/home/sport/$sportId/court/$courtId/book';
}