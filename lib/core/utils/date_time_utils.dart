import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

const String timeFormatPattern = 'EEEE, h:mm a';
const String shortDayTimeFormatPattern = 'EEE h:mm a';
const String dateTimeFormatPattern = 'EEEE, MMMM d, yyyy';
const String dateTimeShortFormatPattern = 'EEE, MMM d, yyyy h:mm a';
const String dayFormatPattern = 'd MMM, yyyy';
const String monthDayFormatPattern = 'MMMM d, yyyy';

extension DateTimeExtension on DateTime {
  /// Return a string representing [date] formatted according to our locale
  String format({
    String pattern = dateTimeFormatPattern,
    String? locale,
  }) {
    if (locale?.isNotEmpty ?? false) {
      initializeDateFormatting(locale);
    }
    return DateFormat(pattern, locale).format(this);
  }

  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isTomorrow() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day + 1;
  }

  bool isYesterday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day - 1;
  }

  String time({String? locale}) => format(pattern: 'h:mm a', locale: locale);

  String timeWithoutPeriod({String? locale}) => format(pattern: 'h:mm', locale: locale);
  String inAmOrPm({String? locale}) => format(pattern: 'a', locale: locale);
}

extension DurationExtension on Duration {
  int get remainingMinutes => inMinutes % 60;

  int get inDaysRounded => (inMicroseconds / Duration.microsecondsPerDay).round();
}
