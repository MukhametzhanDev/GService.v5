import 'package:intl/intl.dart';

String numberFormat(cost) {
  return '${NumberFormat.currency(locale: 'kk', symbol: '').format(cost).toString().split(',')[0]}';
}
