import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class CheckBoxWidget extends StatelessWidget {
  final bool active;
  const CheckBoxWidget({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: active
                  ? ColorComponent.blue['500']!
                  : ColorComponent.gray['300']!),
          color:
              active ? ColorComponent.blue['700'] : ColorComponent.gray['200'],
          borderRadius: BorderRadius.circular(4)),
      child:
          active ? SvgPicture.asset('assets/icons/checkMini.svg') : Container(),
    );
  }
}
