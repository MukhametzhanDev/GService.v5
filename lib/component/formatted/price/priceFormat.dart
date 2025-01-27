import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

String priceFormat(cost, BuildContext context) {
  if (cost.runtimeType == int) {
    if (cost == "" || cost == null || cost == 0) {
      return context.localizations.negotiable;
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
    return context.localizations.negotiable;
  } else {
    return cost.toString();
  }
}

String priceFormatted(cost, BuildContext context) {
  if (cost.runtimeType == int) {
    if (cost == "" || cost == null || cost == 0) {
      return context.localizations.negotiable;
    } else {
      return "${NumberFormat.currency(locale: 'kk', symbol: '').format(cost).toString().split(',')[0]} ₸";
    }
  } else if (cost == null) {
    return context.localizations.negotiable;
  } else {
    return cost;
  }
}

String myPriceFormatted(List prices, BuildContext context) {
  if (prices.length == 1) {
    return "${priceFormat(prices[0]['original_price'], context)} ₸";
  } else if (prices.length == 2) {
    String toPrice = priceFormat(prices[0]['original_price'], context);
    String fromPrice = priceFormat(prices[1]['original_price'], context);
    return "$toPrice ₸ - $fromPrice ₸";
  } else {
    return context.localizations.negotiable;
  }
}
