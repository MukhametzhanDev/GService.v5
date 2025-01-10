// BadgeWidget

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gservice5/component/theme/colorComponent.dart';

class BadgeWidget extends StatelessWidget {
  final Widget body;
  final bool showBadge;
  final badges.BadgePosition position;
  const BadgeWidget(
      {super.key,
      required this.body,
      required this.showBadge,
      required this.position});

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
        badgeAnimation: const badges.BadgeAnimation.fade(),
        position: position,
        badgeStyle: const badges.BadgeStyle(
          badgeColor: Colors.transparent,
          padding: EdgeInsets.all(6),
        ),
        showBadge: showBadge,
        badgeContent: Container(
          height: 18,
          width: 18,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: ColorComponent.red['500'],
              borderRadius: BorderRadius.circular(20)),
          child: const Text("99",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
        ),
        child: body);
  }
}
