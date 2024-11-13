import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class SuccessfulPaymentPage extends StatelessWidget {
  const SuccessfulPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/badgeCheckBig.svg'),
              Divider(height: 16),
              Text("Баланс успешно пополнен",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: Color(0xffeeeeee))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("# 123456789"),
                    Divider(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Пополнения",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        Text("+ ${priceFormat(1000000)} ₸",
                            style: TextStyle(fontWeight: FontWeight.w600))
                      ],
                    ),
                    Divider(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("15 Сентябрь 2024, 04:20",
                            style:
                                TextStyle(color: ColorComponent.gray['500'])),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6, vertical: 0.5),
                          decoration: BoxDecoration(
                              color: ColorComponent.mainColor.withOpacity(.2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text("${priceFormat(100000)} бонус",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Button(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.all(15),
                  title: "В профиль"),
              // Button(
              //     onPressed: () {
              //       Navigator.pop(context);
              //       Navigator.pop(context);
              //     },
              //     backgroundColor: Colors.transparent,
              //     title: "На главную"),
            ],
          )),
    );
  }
}
