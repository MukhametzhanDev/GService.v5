import 'package:intl/intl.dart';

String priceFormat(cost) {
  if (cost.runtimeType == int) {
    if (cost == "" || cost == null || cost == 0) {
      return "Договорная";
    } else {
      return NumberFormat.currency(locale: 'kk', symbol: '')
          .format(cost)
          .toString()
          .split(',')[0];
    }
  } else if (cost.runtimeType == double) {
    cost = cost.round();
    return NumberFormat.currency(locale: 'kk', symbol: '')
        .format(cost)
        .toString()
        .split(',')[0];
  } else if (cost == null) {
    return "Договорная";
  } else {
    return cost.toString();
  }
}

String priceFormatted(cost) {
  if (cost.runtimeType == int) {
    if (cost == "" || cost == null || cost == 0) {
      return "Договорная";
    } else {
      return "${NumberFormat.currency(locale: 'kk', symbol: '').format(cost).toString().split(',')[0]} ₸";
    }
  } else if (cost == null) {
    return "Договорная";
  } else {
    return cost;
  }
}

String myPriceFormatted(List prices) {
  if (prices.length == 1) {
    return "${priceFormat(prices[0]['original_price'])} ₸";
  } else if (prices.length == 2) {
    String toPrice = priceFormat(prices[0]['original_price']);
    String fromPrice = priceFormat(prices[1]['original_price']);
    return "$toPrice ₸ - $fromPrice ₸";
  } else {
    return "Договорная";
  }
}
