import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorComponent.mainColor.withOpacity(.1)),
        child: SvgPicture.asset('assets/icons/bars.svg'),
      ),
    );
  }
}