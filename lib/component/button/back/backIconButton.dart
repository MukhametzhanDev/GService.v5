import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackIconButton extends StatelessWidget {
  const BackIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.padded),
        onPressed: () {
          Navigator.pop(context);
        },
        icon: SvgPicture.asset('assets/icons/left.svg', width: 28));
  }
}
