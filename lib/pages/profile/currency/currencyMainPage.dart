import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/profile/currency/sparePartCurrencyPage.dart';
import 'package:gservice5/pages/profile/currency/transportSaleCurrencyPage.dart';

class CurrencyMainPage extends StatefulWidget {
  const CurrencyMainPage({super.key});

  @override
  State<CurrencyMainPage> createState() => _CurrencyMainPageState();
}

class _CurrencyMainPageState extends State<CurrencyMainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            leading: BackIconButton(),
            title: Text("Моя валюта"),
            bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 50),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 2, color: Color(0xfff4f5f7)))),
                  child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 3,
                      tabs: [
                        Tab(text: "Продажа спецтехники"),
                        Tab(text: "Запчасти")
                      ],
                      indicator: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 2, color: ColorComponent.mainColor)))),
                )),
          ),
          body: TabBarView(
              children: [TransportSaleCurrencyPage(), SparePartCurrencyPage()]),
        ));
  }
}
