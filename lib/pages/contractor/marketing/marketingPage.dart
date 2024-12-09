import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/contractor/dashboard/dashboardPage.dart';

class MarketingPage extends StatefulWidget {
  const MarketingPage({super.key});

  @override
  State<MarketingPage> createState() => _MarketingPageState();
}

class _MarketingPageState extends State<MarketingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Text("Статистика баннера",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600))),
                Row(
                  children: [
                    Text("Показать  все",
                        style: TextStyle(
                            color: ColorComponent.blue['500'],
                            fontWeight: FontWeight.w500)),
                    Divider(indent: 4),
                    SvgPicture.asset('assets/icons/rightBlue.svg')
                  ],
                )
              ],
            ),
            Divider(height: 12),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text("Статистика объявлении",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600))),
                    Row(
                      children: [
                        Text("Показать  все",
                            style: TextStyle(
                                color: ColorComponent.blue['500'],
                                fontWeight: FontWeight.w500)),
                        Divider(indent: 4),
                        SvgPicture.asset('assets/icons/rightBlue.svg')
                      ],
                    )
                  ],
                ),
                Divider(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ContainerWidget(Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                                color: ColorComponent.mainColor.withOpacity(.2),
                                borderRadius: BorderRadius.circular(4)),
                            child: SvgPicture.asset('assets/icons/message.svg',
                                color: Colors.black),
                          ),
                          Divider(indent: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  numberFormat(1234),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Divider(height: 4),
                                Text("Сообщения от пользователей")
                              ],
                            ),
                          )
                        ],
                      )),
                    ),
                    Divider(indent: 12),
                    Expanded(
                      child: ContainerWidget(Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                                color: ColorComponent.mainColor.withOpacity(.2),
                                borderRadius: BorderRadius.circular(4)),
                            child: SvgPicture.asset('assets/icons/eye.svg',
                                color: Colors.black),
                          ),
                          Divider(indent: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  numberFormat(1234),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Divider(height: 4),
                                Text("Просмотры объявлений")
                              ],
                            ),
                          )
                        ],
                      )),
                    ),
                  ],
                ),
                Divider(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ContainerWidget(Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                                color: ColorComponent.mainColor.withOpacity(.2),
                                borderRadius: BorderRadius.circular(4)),
                            child: SvgPicture.asset('assets/icons/phone.svg',
                                color: Colors.black),
                          ),
                          Divider(indent: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  numberFormat(1234),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Divider(height: 4),
                                Text("Просмотры контактов")
                              ],
                            ),
                          )
                        ],
                      )),
                    ),
                    Divider(indent: 12),
                    Expanded(
                      child: ContainerWidget(Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                                color: ColorComponent.mainColor.withOpacity(.2),
                                borderRadius: BorderRadius.circular(4)),
                            child: SvgPicture.asset('assets/icons/share.svg',
                                color: Colors.black),
                          ),
                          Divider(indent: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  numberFormat(1234),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Divider(height: 4),
                                Text("Поделились объявлениями")
                              ],
                            ),
                          )
                        ],
                      )),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
