import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/modal/contact/shortContactModal.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class SmallApplicationItem extends StatefulWidget {
  final void Function(int id) onPressed;
  final Map data;
  final String position;
  const SmallApplicationItem(
      {super.key,
      required this.onPressed,
      required this.data,
      required this.position});

  @override
  State<SmallApplicationItem> createState() => _SmallApplicationItemState();
}

class _SmallApplicationItemState extends State<SmallApplicationItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed(1);
      },
      onLongPress: () => onLongPressShowNumber({}, context),
      child: Container(
        height: 110,
        margin: EdgeInsets.symmetric(horizontal: 4),
        constraints: BoxConstraints(
            maxWidth: widget.position == "main"
                ? MediaQuery.of(context).size.width / 1.3
                : MediaQuery.of(context).size.width - 30),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: Color(0xffeeeeee))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Нужен экскаватор 2-ух кубовый",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: ColorComponent.blue['700']),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  height: 20,
                  margin: EdgeInsets.only(left: 8),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ColorComponent.mainColor,
                      borderRadius: BorderRadius.circular(4)),
                  child: Text("Аренда",
                      style: TextStyle(
                          height: 1,
                          fontSize: 11,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            Text(priceFormat(1500000),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  SvgPicture.asset('assets/icons/pin.svg',
                      width: 16, color: ColorComponent.gray['500']),
                  Divider(indent: 4),
                  Text(
                    "г. Алматы",
                    style: TextStyle(
                        fontSize: 12,
                        color: ColorComponent.gray['500'],
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text("15 Сент.",
                  style: TextStyle(
                      fontSize: 12, color: ColorComponent.gray['500'])),
            ])
          ],
        ),
      ),
    );
  }
}