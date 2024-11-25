import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:intl/intl.dart';

class AnalyticAdWidget extends StatelessWidget {
  final Map data;
  const AnalyticAdWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 4),
        Row(
          children: [
            SvgPicture.asset('assets/icons/eye.svg',
                width: 22, color: ColorComponent.mainColor),
            SizedBox(width: 8),
            Text(
              NumberFormat.currency(locale: 'kk', symbol: '')
                  .format(data['viewed'])
                  .toString()
                  .split(',')[0],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 8),
            Text("Просмотр", style: TextStyle(fontSize: 16))
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            SvgPicture.asset('assets/icons/message.svg',
                width: 22, color: ColorComponent.mainColor),
            SizedBox(width: 8),
            Text(
              NumberFormat.currency(locale: 'kk', symbol: '')
                  .format(data['wrote'])
                  .toString()
                  .split(',')[0],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 8),
            Text(
              "Написали",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            SvgPicture.asset('assets/icons/phone.svg',
                width: 22, color: ColorComponent.mainColor),
            SizedBox(width: 8),
            Text(
              NumberFormat.currency(locale: 'kk', symbol: '')
                  .format(data['called'])
                  .toString()
                  .split(',')[0],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 8),
            Text(
              "Позвонили",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            SvgPicture.asset('assets/icons/heartOutline.svg',
                width: 22, color: ColorComponent.mainColor),
            SizedBox(width: 8),
            Text(
              NumberFormat.currency(locale: 'kk', symbol: '')
                  .format(data['favorites'])
                  .toString()
                  .split(',')[0],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 8),
            Text(
              "В избранные",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            SvgPicture.asset('assets/icons/share.svg',
                width: 22, color: ColorComponent.mainColor),
            SizedBox(width: 8),
            Text(
              NumberFormat.currency(locale: 'kk', symbol: '')
                  .format(data['shared'])
                  .toString()
                  .split(',')[0],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 8),
            Text(
              "Поделились",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
        SizedBox(height: 6),
      ],
    );
  }
}
