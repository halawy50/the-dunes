import 'package:intl/intl.dart';

enum DateRangeOption { today, thisMonth, lastMonth, lastYear, custom }

class BookingFilterDateRangeHelper {
  static DateTime getTodayStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 0, 0);
  }

  static DateTime getTodayEnd() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59);
  }

  static DateTime getThisMonthStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1, 0, 0);
  }

  static DateTime getThisMonthEnd() {
    final now = DateTime.now();
    final lastDay = DateTime(now.year, now.month + 1, 0);
    return DateTime(now.year, now.month, lastDay.day, 23, 59);
  }

  static DateTime getLastMonthStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month - 1, 1, 0, 0);
  }

  static DateTime getLastMonthEnd() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 0, 23, 59);
  }

  static DateTime getLastYearStart() {
    final now = DateTime.now();
    return DateTime(now.year - 1, 1, 1, 0, 0);
  }

  static DateTime getLastYearEnd() {
    final now = DateTime.now();
    return DateTime(now.year - 1, 12, 31, 23, 59);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('yyyy/MM/dd HH:mm').format(date);
  }

  static String formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }

  static DateTime? parseDateTime(String dateStr) {
    try {
      return DateFormat('yyyy/MM/dd HH:mm').parse(dateStr);
    } catch (e) {
      return null;
    }
  }
}

