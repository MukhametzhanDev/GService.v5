import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class ModalButtonComponent extends StatelessWidget {
  final bool padding;
  final onPressed;
  final String title;
  final subtitle;
  const ModalButtonComponent(
      {super.key,
      required this.padding,
      @required this.onPressed,
      required this.title,
      @required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => onPressed(),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 50,
              decoration: BoxDecoration(
                  color: ColorComponent.gray['50'],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Color(0xffe5e7eb))),
              margin: EdgeInsets.symmetric(horizontal: padding ? 16 : 0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(subtitle?['title'] ?? "Выберите",
                          style: TextStyle(
                              color: subtitle?['title'] == null
                                  ? ColorComponent.gray['500']
                                  : Colors.black))),
                  SvgPicture.asset('assets/icons/down.svg',
                      color: ColorComponent.gray['400'])
                ],
              )),
        ),
      ],
    );
  }
}
