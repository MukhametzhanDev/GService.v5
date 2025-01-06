import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/application/sectionCreateApplicationPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CreateCompanyWidget extends StatelessWidget {
  const CreateCompanyWidget({super.key});

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
          const Text("Здесь могла быть ваша компания",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const Divider(height: 10),
          Text(
              "Привлекайте новых клиентов и повышайте узнаваемость вашего бизнеса.",
              style: TextStyle(color: ColorComponent.gray['600'], height: 1.6),
              textAlign: TextAlign.center),
          // RichText(
          //   overflow: TextOverflow.ellipsis,
          //   maxLines: 3,
          //   textAlign: TextAlign.center,
          //   text: TextSpan(
          //       style: TextStyle(height: 1.4, color: Colors.black),
          //       children: [
          //         TextSpan(text: "Получите", style: TextStyle()),
          //         TextSpan(
          //             text: LocaleKeys.a2_months_free.tr(),
          //             style: TextStyle(fontWeight: FontWeight.w600)),
          //         TextSpan(text: LocaleKeys.and_increase_your_sales_with.tr()),
          //       ]),
          // ),
          const Divider(indent: 6),
          SizedBox(
            height: 38,
            child: Button(
                onPressed: () {
                  showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          const SectionCreateApplicationPage());
                },
                title: "Разместить компанию"),
          )
        ],
      ),
    );
  }
}
