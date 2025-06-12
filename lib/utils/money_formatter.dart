import 'package:intl/intl.dart';

class MoneyFormatter {
  static format(int amount) {
    return NumberFormat('###,###,###', 'id_ID').format(amount);
  }
}
