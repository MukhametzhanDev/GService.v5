import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gservice5/component/bar/bottomBar/contactBottomBarWidget.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/price/priceTextWidget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void onLongPressShowNumber(Map data, BuildContext context) {
  HapticFeedback.mediumImpact();
  showCupertinoModalBottomSheet(
    context: context,
    barrierColor: Colors.black.withOpacity(.3),
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).padding.bottom + 163,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PriceTextWidget(prices: data['prices'], fontSize: 16),
                // Text(priceFormat(data['price']),
                //     style:
                //         TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Divider(indent: 8),
                Text(
                  data['title'],
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ColorComponent.blue['500']),
                )
              ],
            ),
          ),
          bottomNavigationBar: ContactBottomBarWidget(),
        ),
      );
    },
  );
}
