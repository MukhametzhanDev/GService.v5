import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:intl/intl.dart';

class MyApplicationItem extends StatelessWidget {
  final Map data;
  final void Function(int id) onPressed;
  const MyApplicationItem(
      {super.key, required this.data, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed(data['id']);
      },
      child: Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Color(0xfff4f4f4)))),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Divider(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                height: 24,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: ColorComponent.mainColor),
                child: Text(data['category']['title'],
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
          ]),
          Divider(height: 12),
          Text(data['transport_type']['title'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          Divider(height: 8),
          Text(myPriceFormatted(data['prices']),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Divider(height: 12),
          Text(data['description'],
              maxLines: 2, overflow: TextOverflow.ellipsis),
          Divider(height: 12),
          Row(children: [
            SvgPicture.asset("assets/icons/pin.svg",
                width: 16, color: ColorComponent.gray['500']),
            Divider(indent: 4),
            Text(data['city']['title'],
                style: TextStyle(
                    fontSize: 12,
                    // fontWeight: FontWeight.3500,
                    color: ColorComponent.gray['500'])),
            Divider(indent: 12),
            Text(formattedDate(data['created_at']),
                style:
                    TextStyle(fontSize: 12, color: ColorComponent.gray['500'])),
            Expanded(child: Container()),
            Row(children: [
              SvgPicture.asset("assets/icons/eye.svg"),
              Divider(indent: 4),
              Text(data['views'].toString(),
                  style: TextStyle(
                      fontSize: 12, color: ColorComponent.gray['500']))
            ])
          ]),
          Divider(height: 16),
        ]),
      ),
    );
  }
}

String formattedDate(isoDate) {
  DateTime dateTime = DateTime.parse(isoDate);
  String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
  return formattedDate;
}
