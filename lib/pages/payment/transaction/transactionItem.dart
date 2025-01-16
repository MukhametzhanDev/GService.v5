import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/payment/transaction/viewReceiptPage.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final Map data;
  const TransactionItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    bool replenishment = data['is_replenishment'];
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ViewReceiptPage()));
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xfff4f5f7)))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Expanded(
                    child: Text(data['title'],
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500))),
                Text(
                    "${replenishment ? "+" : "-"} ${numberFormat(data['total_price'])} ₸",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: replenishment
                            ? const Color(0xff057A55)
                            : Colors.red)),
              ],
            ),
            const Divider(height: 6),
            Row(
              children: [
                Text("#${data['id']}",
                    style: TextStyle(
                        fontSize: 13, color: ColorComponent.gray['500'])),
                data['bonus'] == null
                    ? Container()
                    : Expanded(
                        child: Text("${numberFormat(1000)} Б",
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                      )
              ],
            ),
            const Divider(height: 6),
            Row(
              children: [
                Row(
                  children: [
                    Text("Показать чек",
                        style: TextStyle(
                            fontSize: 14,
                            // fontWeight: FontWeight.w500,
                            color: ColorComponent.blue['500'])),
                    const Divider(indent: 4),
                    SvgPicture.asset('assets/icons/receiptOutline.svg')
                  ],
                ),
                Expanded(
                    child: Text(
                  formattedISOTime(data['created_at']),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: ColorComponent.gray['500'], fontSize: 13),
                ))
              ],
            )
          ])),
    );
  }
}

String formattedISOTime(String isoDate) {
  DateTime parsedDate = DateTime.parse(isoDate);
  String formattedDate = DateFormat('HH:mm', 'ru').format(parsedDate);
  return formattedDate;
}
