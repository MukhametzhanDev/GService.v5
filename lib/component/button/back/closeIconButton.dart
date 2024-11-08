import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class CloseIconButton extends StatelessWidget {
  final Color? iconColor;
  final bool padding;
  const CloseIconButton(
      {super.key, @required this.iconColor, required this.padding});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        style: ButtonStyle(
          tapTargetSize: padding
              ? MaterialTapTargetSize.padded
              : MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        icon: SvgPicture.asset('assets/icons/close.svg',
            color: iconColor ?? ColorComponent.gray['500']));
  }
}
