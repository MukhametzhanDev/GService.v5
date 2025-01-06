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
          const Divider(indent: 15),
          SvgPicture.asset('assets/icons/logo.svg', width: 40),
          const Divider(indent: 11),
          const SizedBox(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("GService.kz",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 1)),
                          Divider(height: 3),
                  Text(
                    "мир спецтехники",
                    style: TextStyle(fontSize: 9.5),
                  )
                ]),
          )
        ]);
  }
}
