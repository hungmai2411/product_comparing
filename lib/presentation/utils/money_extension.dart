import 'package:intl/intl.dart';

extension MoneyExtension on int {
  String get toMoney {
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    ).format(this);
  }
}
