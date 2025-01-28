import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:intl/intl.dart';

class AnalyticAdItemWidget extends StatelessWidget {
  final Map data;
  const AnalyticAdItemWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatisticWidget("eye.svg", data['viewed']),
        // Divider(indent: 10),
        StatisticWidget("message.svg", data['write']),
        // Divider(indent: 10),
        StatisticWidget("phoneOutline.svg", data['called']),
        // Divider(indent: 10),
        StatisticWidget("heartOutline.svg", data['favorite']),
        // Divider(indent: 10),
        StatisticWidget("share.svg", data['share']),
      ],
    );
  }
}

Widget StatisticWidget(String icon, int count) {
  return Row(
    children: [
      Container(
        width: 22,
        height: 22,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: ColorComponent.mainColor.withOpacity(.15)),
        child: SvgPicture.asset('assets/icons/$icon',
            width: 20, color: Colors.black),
      ),
      const SizedBox(width: 8),
      Text(
        NumberFormat.currency(locale: 'kk', symbol: '')
            .format(count)
            .toString()
            .split(',')[0],
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ],
  );
}
