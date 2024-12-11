import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gservice5/pages/create/data/createData.dart';

class FilterButton extends StatefulWidget {
  final VoidCallback showFilterPage;
  const FilterButton({super.key, required this.showFilterPage});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      badgeAnimation: const badges.BadgeAnimation.fade(),
      position: badges.BadgePosition.topEnd(top: -8, end: 4),
      badgeStyle: const badges.BadgeStyle(
        badgeColor: Colors.transparent,
        padding: EdgeInsets.all(6),
      ),
      showBadge: FilterData.data.isNotEmpty,
      badgeContent: Container(
        height: 12,
        width: 12,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: ColorComponent.red['500'],
            borderRadius: BorderRadius.circular(20)),
      ),
      child: GestureDetector(
          onTap: widget.showFilterPage,
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorComponent.mainColor),
            child: SvgPicture.asset("assets/icons/filter.svg", width: 20),
          )),
    );
  }
}
