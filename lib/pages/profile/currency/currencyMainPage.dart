import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/profile/currency/sparePartCurrencyPage.dart';
import 'package:gservice5/pages/profile/currency/transportSaleCurrencyPage.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

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
            leadingWidth: 200,
            leading: const BackTitleButton(title: "Конвертор валют"),
            bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 50),
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 2, color: Color(0xfff4f5f7)))),
                  child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 3,
                      tabs:  [
                        Tab(text: context.localizations.sale_of_equipment),
                        Tab(text: context.localizations.spare_parts)
                      ],
                      indicator: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 2, color: ColorComponent.mainColor)))),
                )),
          ),
          body: const TabBarView(
              children: [TransportSaleCurrencyPage(), SparePartCurrencyPage()]),
        ));
  }
}
