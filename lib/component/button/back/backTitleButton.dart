import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackTitleButton extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  const BackTitleButton(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.padded),
        onPressed: onPressed,
        icon: Row(
          children: [
            Divider(indent: 10),
            SvgPicture.asset('assets/icons/left.svg', width: 22),
            Divider(indent: 8),
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
          ],
        ));
  }
}
