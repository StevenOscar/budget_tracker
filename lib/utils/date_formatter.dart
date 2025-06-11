import 'package:intl/intl.dart';

class DateFormatter {
  static  formatDayDateMonthYear(DateTime date) {
    return DateFormat("EEEE, d MMMM yyyy", "EN_en").format(date);
  }

  static  formatMonthYear(DateTime date) {
    return DateFormat("MMMM yyyy").format(date);
  }

  static formatDateMonthYear(DateTime date){
    return DateFormat("d MMMM yy").format(date);
  }
}
