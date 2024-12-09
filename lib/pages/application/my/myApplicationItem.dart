import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/application/my/removeApplicationModal.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MyApplicationItem extends StatefulWidget {
  final Map data;
  final void Function(int id) onPressed;
  final void Function(int id) removeItem;
  const MyApplicationItem(
      {super.key,
      required this.data,
      required this.onPressed,
      required this.removeItem});

  @override
  State<MyApplicationItem> createState() => _MyApplicationItemState();
}

class _MyApplicationItemState extends State<MyApplicationItem> {
  void showRemoveModal() {
    showCupertinoModalBottomSheet(
            context: context,
            builder: (context) => RemoveApplicationModal(id: widget.data['id']))
        .then((value) {
      widget.removeItem(widget.data['id']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed(widget.data['id']);
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
                child: Text(widget.data['category']['title'],
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
          ]),
          Divider(height: 12),
          Text(widget.data['transport_type']['title'],
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ColorComponent.blue['500'])),
          Divider(height: 8),
          // Text(myPriceFormatted(data['prices']),
          // style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          // Divider(height: 12),
          Text(widget.data['description'],
              maxLines: 2, overflow: TextOverflow.ellipsis),
          Divider(height: 12),
          SizedBox(
            height: 40,
            child: Button(
                onPressed: showRemoveModal,
                backgroundColor: ColorComponent.red['100'],
                titleColor: ColorComponent.red['700'],
                title: "Удалить"),
          ),
          Divider(height: 12),
          Divider(height: 1, color: ColorComponent.gray['100']),
          Divider(height: 12),
          Row(children: [
            SvgPicture.asset("assets/icons/pin.svg",
                width: 16, color: ColorComponent.gray['500']),
            Divider(indent: 4),
            Text(widget.data['city']['title'],
                style: TextStyle(
                    fontSize: 12,
                    // fontWeight: FontWeight.3500,
                    color: ColorComponent.gray['500'])),
            Divider(indent: 12),
            Text(formattedDate(widget.data['created_at']),
                style:
                    TextStyle(fontSize: 12, color: ColorComponent.gray['500'])),
            Expanded(child: Container()),
            Row(children: [
              SvgPicture.asset("assets/icons/eye.svg"),
              Divider(indent: 4),
              Text(widget.data['views'].toString(),
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
