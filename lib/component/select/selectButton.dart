import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class SelectButton extends StatefulWidget {
  final String title;
  final void Function() onPressed;
  const SelectButton({super.key, required this.title, required this.onPressed});

  @override
  State<SelectButton> createState() => _SelectButtonState();
}

class _SelectButtonState extends State<SelectButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: 48,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Color(0xffF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: Color(0xffE5E5EA))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title,
                style: TextStyle(color: ColorComponent.gray['500'])),
            SvgPicture.asset('assets/icons/down.svg')
          ],
        ),
      ),
    );
  }
}
