import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gservice5/provider/adFilterProvider.dart';
import 'package:provider/provider.dart';

class FilterButton extends StatefulWidget {
  final VoidCallback showFilterPage;
  final String? fromPage;
  const FilterButton({super.key, required this.showFilterPage, this.fromPage});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  final analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<AdFilterProvider>(builder: (context, data, child) {
      Iterable keys = data.data.keys;
      return badges.Badge(
        badgeAnimation: const badges.BadgeAnimation.fade(),
        position: badges.BadgePosition.topEnd(top: -8, end: 4),
        badgeStyle: const badges.BadgeStyle(
          badgeColor: Colors.transparent,
          padding: EdgeInsets.all(6),
        ),
        showBadge: keys.length > 1,
        badgeContent: Container(
          height: 12,
          width: 12,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: ColorComponent.red['500'],
              borderRadius: BorderRadius.circular(20)),
        ),
        child: GestureDetector(
            onTap: () {
              widget.showFilterPage();
              analytics.logEvent(name: GAEventName.buttonClick, parameters: {
                GAKey.buttonName: GAParams.icBtnFilter,
                GAKey.screenName: widget.fromPage ?? ''
              }).catchError((e) {
                if (kDebugMode) {
                  debugPrint(e);
                }
              });
            },
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorComponent.mainColor),
              child: SvgPicture.asset("assets/icons/filter.svg", width: 20),
            )),
      );
    });
  }
}
