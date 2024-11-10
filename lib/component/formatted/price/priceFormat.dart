import 'package:intl/intl.dart';

String priceFormat(cost) {
  if (cost.runtimeType == int) {
    if (cost == "" || cost == null || cost == 0) {
      return "Договорная";
    } else {
      return '${NumberFormat.currency(locale: 'kk', symbol: '').format(cost).toString().split(',')[0]}';
    }
  } else if (cost == null) {
    return "Договорная";
  } else {
    return cost;
  }
}


