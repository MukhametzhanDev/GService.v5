import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LeadingLogo extends StatelessWidget {
  const LeadingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Divider(indent: 15),
          SvgPicture.asset('assets/icons/logo.svg', width: 40),
          Divider(indent: 11),
          SizedBox(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("GService",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 1)),
                  Text(
                    "мир спецтехники",
                    style: TextStyle(fontSize: 9.5),
                  )
                ]),
          )
        ]);
  }
}
