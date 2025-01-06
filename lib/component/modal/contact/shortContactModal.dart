import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gservice5/component/bar/bottomBar/contactBottomBarWidget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void onLongPressShowNumber(Map data, BuildContext context) {
  HapticFeedback.mediumImpact().catchError((e) {});
  showCupertinoModalBottomSheet(
    context: context,
    barrierColor: Colors.black.withOpacity(.3),
    builder: (context) {
      return ContactstListModal(phones: data['phones']);
    },
  );
}
