import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? titleColor;
  final String? icon;
  final String title;
  final EdgeInsets? padding;
  final double? widthIcon;
  const Button(
      {super.key,
      required this.onPressed,
      @required this.backgroundColor,
      @required this.titleColor,
      @required this.icon,
      @required this.padding,
      @required this.widthIcon,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
              backgroundColor: backgroundColor ?? ColorComponent.mainColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(minHeight: 40, maxHeight: 49),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon == null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: SvgPicture.asset('assets/icons/$icon',
                            width: widthIcon ?? 16,
                            color: titleColor ?? Colors.black),
                      ),
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: titleColor ?? Colors.black))
              ],
            ),
          )),
    );
  }
}
