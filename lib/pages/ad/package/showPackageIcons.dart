import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ShowPackageIcons extends StatefulWidget {
  const ShowPackageIcons({super.key});

  @override
  State<ShowPackageIcons> createState() => _ShowPackageIconsState();
}

class _ShowPackageIconsState extends State<ShowPackageIcons> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          width: 24,
          margin: EdgeInsets.only(left: 6),
          child: SvgPicture.asset(
            'assets/icons/checkCircle.svg',
            width: 22,
          )),
      Container(
          width: 24,
          margin: EdgeInsets.only(left: 6),
          child: SvgPicture.asset(
            'assets/icons/starPackage.svg',
            width: 22,
          )),
      GestureDetector(
        onTap: () {
          showCupertinoModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(height: 200);
            },
          );
        },
        child: Container(
            width: 24,
            margin: EdgeInsets.only(left: 6),
            child: SvgPicture.asset('assets/icons/fire.svg')),
      ),
    ]);
  }
}
