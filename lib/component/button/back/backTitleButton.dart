import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackTitleButton extends StatelessWidget {
  final String title;
  final onPressed;
  const BackTitleButton({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.padded),
        onPressed: () {
          onPressed == null ? Navigator.pop(context) : onPressed();
        },
        icon: Row(
          children: [
            const Divider(indent: 10),
            SvgPicture.asset('assets/icons/left.svg', width: 22),
            const Divider(indent: 8),
            Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
          ],
        ));
  }
}
