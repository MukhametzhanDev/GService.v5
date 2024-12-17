import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/date/formattedDate.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/application/my/cancelApplicationModal.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MyApplicationItem extends StatefulWidget {
  final Map data;
  final void Function(int id) onPressed;
  final void Function(int id) removeItem;
  final void Function(int id) restoreItem;
  const MyApplicationItem(
      {super.key,
      required this.data,
      required this.onPressed,
      required this.removeItem,
      required this.restoreItem});

  @override
  State<MyApplicationItem> createState() => _MyApplicationItemState();
}

class _MyApplicationItemState extends State<MyApplicationItem> {
  void showRemoveModal() {
    showCupertinoModalBottomSheet(
            context: context,
            builder: (context) => CancelApplicationModal(id: widget.data['id']))
        .then((value) {
      if (value == "update") {
        widget.removeItem(widget.data['id']);
      }
    });
  }

  Future restoreAd() async {
    showModalLoader(context);
    print(widget.data['id']);
    try {
      Response response =
          await dio.post("/restore-application/${widget.data['id']}");
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        widget.restoreItem(widget.data['id']);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showServerErrorMessage(context);
    }
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
          Divider(height: 12),
          Text(widget.data['title'],
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
            child: widget.data['status'] == "canceled"
                ? Button(
                    onPressed: restoreAd,
                    backgroundColor: ColorComponent.blue['100'],
                    titleColor: ColorComponent.blue['700'],
                    title: "Восстановить")
                : Button(
                    onPressed: showRemoveModal,
                    backgroundColor: ColorComponent.red['100'],
                    titleColor: ColorComponent.red['700'],
                    title: "Удалить"),
          ),
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
            Text(formattedDate(widget.data['created_at'], "dd MMMM yyyy"),
                style:
                    TextStyle(fontSize: 12, color: ColorComponent.gray['500'])),
            Expanded(child: Container()),
            Row(children: [
              SvgPicture.asset("assets/icons/eye.svg"),
              Divider(indent: 4),
              Text(widget.data['statistics']['viewed'].toString(),
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
