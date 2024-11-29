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
        StatisticWidget("eye.svg", data['viewed'], "Просмотры объявления"),
        SizedBox(height: 16),
        StatisticWidget(
            "message.svg", data['wrote'], "Сообщения от покупателей"),
        SizedBox(height: 16),
        StatisticWidget("phone.svg", data['called'], "Просмотр контактов"),
        SizedBox(height: 16),
        StatisticWidget("heartOutline.svg", data['favorites'], "В избранные"),
        SizedBox(height: 16),
        StatisticWidget("share.svg", data['shared'], "Поделились объявлениями"),
      ],
    );
  }
}

Widget StatisticWidget(String icon, int count, String title) {
  return Row(
    children: [
      Container(
        width: 24,
        height: 24,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: ColorComponent.mainColor.withOpacity(.15)),
        child: SvgPicture.asset('assets/icons/$icon',
            width: 22, color: Colors.black),
      ),
      SizedBox(width: 8),
      Text(
        NumberFormat.currency(locale: 'kk', symbol: '')
            .format(count)
            .toString()
            .split(',')[0],
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      SizedBox(width: 8),
      Text(title, style: TextStyle(fontSize: 16))
    ],
  );
}
