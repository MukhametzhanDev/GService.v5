import 'package:flutter/material.dart';
import 'package:gservice5/component/bar/bottomBar/contactBottomBarWidget.dart';
import 'package:gservice5/component/modal/contact/shortContactModal.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/viewAdPage.dart';
import 'package:gservice5/pages/leads/viewLeadModal.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LeadItem extends StatefulWidget {
  final Map data;
  const LeadItem({super.key, required this.data});

  @override
  State<LeadItem> createState() => _LeadItemState();
}

class _LeadItemState extends State<LeadItem> {
  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
      mask: '+# (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalBottomSheet(
            context: context,
            builder: (context) => ViewLeadModal(data: widget.data));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            border: const Border(
                bottom: BorderSide(width: 6, color: Color(0xfff4f5f7)))),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      maskFormatter.maskText(widget.data['phone']),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    )),
                    // Container(
                    //     padding:
                    //         EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(5),
                    //         color: ColorComponent.mainColor),
                    //     child: Text("Ожидает",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w500, fontSize: 11))),
                  ],
                ),
                Divider(height: 10),
                Row(
                  children: [
                    Expanded(child: Text(widget.data['name'])),
                    Text(
                      formattedDate(widget.data['created_at']),
                      style: TextStyle(
                          fontSize: 12, color: ColorComponent.gray['500']),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

String formattedDate(isoDate) {
  DateTime dateTime = DateTime.parse(isoDate);
  String formattedDate = DateFormat('HH:mm dd MMM').format(dateTime);
  return formattedDate;
}
