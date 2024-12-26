import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/application/sectionCreateApplicationPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CreateApplicationWidgetAdList extends StatelessWidget {
  const CreateApplicationWidgetAdList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: const BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 6, color: Color(0xfff4f5f7)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Оставьте заказ",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const Divider(height: 10),
          Text(
              "Если вы не нашли или трудно найти спецтехнику, вы можете разместить заказ. Ваш заказ будет показано на официальных диллерах",
              style: TextStyle(color: ColorComponent.gray['600'], height: 1.6),
              textAlign: TextAlign.center),
          const Divider(indent: 6),
          SizedBox(
            height: 38,
            child: Button(
                onPressed: () {
                  showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) => const SectionCreateApplicationPage());
                },
                title: "Разместить заказ"),
          )
        ],
      ),
    );
  }
}
