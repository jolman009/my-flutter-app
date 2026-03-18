import 'package:intl/intl.dart';

class AppDateUtils {
  static final DateFormat _shortDate = DateFormat('MMM d');
  static final DateFormat _fullDate = DateFormat('EEE, MMM d');

  static String short(DateTime value) => _shortDate.format(value);

  static String full(DateTime value) => _fullDate.format(value);

  static DateTime startOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isToday(DateTime value) {
    return isSameDay(value, DateTime.now());
  }

  static bool isOverdue(DateTime value) {
    final now = startOfDay(DateTime.now());
    return startOfDay(value).isBefore(now);
  }
}

