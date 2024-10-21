import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class BadgeBottomTab extends StatelessWidget {
  final Widget tab;
  final bool showBadge;
  const BadgeBottomTab({super.key, required this.tab, required this.showBadge});

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
        badgeAnimation: const badges.BadgeAnimation.fade(),
        position: badges.BadgePosition.topEnd(top: -12, end: 0),
        badgeStyle: const badges.BadgeStyle(
          badgeColor: Colors.transparent,
          padding: EdgeInsets.all(6),
        ),
        showBadge: showBadge,
        badgeContent: Container(
          height: 16,
          width: 16,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.red[500], borderRadius: BorderRadius.circular(20)),
          child: const Text("99",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
        ),
        child: tab);
  }
}
