import 'package:flutter/material.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class PriceTextWidget extends StatelessWidget {
  final List? prices;
  final double? fontSize;
  const PriceTextWidget(
      {super.key, required this.prices, @required this.fontSize});

  @override
  Widget build(BuildContext context) {
    if (prices == null || prices!.isEmpty) {
      return Text("Договорная",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: fontSize ?? 15));
    } else if (prices != null && prices!.length == 1) {
      Map price = prices![0];
      return Text("${priceFormat(price['price'])} ₸",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: fontSize ?? 15));
    } else if (prices!.length == 2) {
      return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        RichText(
            text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black),
                children: [
              TextSpan(
                  text: "${priceFormat(prices![1]['price'])} ₸",
                  style: TextStyle(fontSize: fontSize ?? 15)),
              TextSpan(
                  text: " /час",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: ColorComponent.gray['600'],
                      fontSize: (fontSize ?? 15) - 1)),
            ])),
        const Text("  |  "),
        RichText(
            text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.black),
                children: [
              TextSpan(
                  text: "${priceFormat(prices![0]['price'])} ₸",
                  style: TextStyle(fontSize: fontSize ?? 15)),
              TextSpan(
                  text: " /смена",
                  style: TextStyle(
                      color: ColorComponent.gray['600'],
                      fontWeight: FontWeight.w400,
                      fontSize: (fontSize ?? 15) - 1)),
            ])),
      ]);
    } else {
      return const Text("");
    }
  }
}
