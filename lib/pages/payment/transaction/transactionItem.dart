import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Color(0xfff4f5f7)))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              const Text("Оплата", style: TextStyle(fontSize: 15)),
              Expanded(
                child: Text("+ ${numberFormat(100000)} ₸",
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: false ? Colors.red : Color(0xff057A55))),
              ),
            ],
          ),
          const Divider(height: 6),
          Row(
            children: [
              Text("#123123213",
                  style: TextStyle(
                      fontSize: 13, color: ColorComponent.gray['500'])),
              Expanded(
                child: Text("${numberFormat(1000)} Б",
                    textAlign: TextAlign.end,
                    style:
                        const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
                          fontWeight: FontWeight.w500,
                          color: ColorComponent.blue['500'])),
                  const Divider(indent: 4),
                  SvgPicture.asset('assets/icons/receiptOutline.svg')
                ],
              ),
              // Expanded(
              //     child: Text(
              //   "12:34",
              //   textAlign: TextAlign.end,
              //   style: TextStyle(
              //       color: ColorComponent.gray['500'],
              //       fontSize: 13),
              // ))
            ],
          )
        ]));
  }
}
