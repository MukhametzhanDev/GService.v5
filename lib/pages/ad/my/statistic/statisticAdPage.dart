import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/select/selectButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/price/priceTextWidget.dart';
import 'package:gservice5/pages/ad/my/statistic/chartWidget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class StatisticAdPage extends StatefulWidget {
  final Map data;
  const StatisticAdPage({super.key, required this.data});

  @override
  State<StatisticAdPage> createState() => _StatisticAdPageState();
}

class _StatisticAdPageState extends State<StatisticAdPage> {
  final List _tabs = ["Сообщение", "Просмотры", "Контакты", "Написали"];

  Map currentPeriod = {"title": "За все время", "type": ""};

  void showModalPeriod() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => ModalPeriod(changedPeriod: changedPeriod));
  }

  void changedPeriod(Map value) {
    currentPeriod = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
          appBar: AppBar(
            leadingWidth: 200,
            leading: BackTitleButton(
                title: "Статистика", onPressed: () => Navigator.pop(context)),
            bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 48),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 2, color: ColorComponent.gray['200']!))),
                  child: TabBar(
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 3,
                      tabAlignment: TabAlignment.start,
                      tabs: _tabs.map((value) {
                        return Tab(text: value);
                      }).toList()),
                )),
          ),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 15, left: 15, right: 15, bottom: 7.5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                    color: ColorComponent.gray['100'],
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    CacheImage(
                        url: widget.data['images'][0],
                        width: 50,
                        height: 50,
                        borderRadius: 4),
                    const Divider(indent: 15),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data['title'],
                          // data['title'],
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // const SizedBox(height: 8),
                        PriceTextWidget(prices: widget.data['prices'])
                      ],
                    ))
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                    children: _tabs.map((value) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: "Общее: ",
                                      style: TextStyle(
                                          color: ColorComponent.gray['500'])),
                                  TextSpan(text: numberFormat(32000)),
                                ])),
                        const Divider(height: 20),
                        const ChartWidget(),
                        const Divider(height: 20),
                        SelectButton(
                            title: currentPeriod['title'],
                            active: currentPeriod.isNotEmpty,
                            onPressed: showModalPeriod),
                        const Divider(height: 20),
                        Column(
                            children: List.generate(10, (index) => index)
                                .map((value) {
                          return Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xfff4f5f7)))),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Text("7 Сентябрь 2024 ",
                                          style: TextStyle(
                                              color:
                                                  ColorComponent.gray['600']))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                    numberFormat(5400),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ))
                                ]),
                          );
                        }).toList()),
                        SizedBox(height: MediaQuery.of(context).padding.bottom)
                      ],
                    ),
                  );
                }).toList()),
              ),
            ],
          )),
    );
  }
}

class ModalPeriod extends StatelessWidget {
  final void Function(Map value) changedPeriod;
  ModalPeriod({super.key, required this.changedPeriod});
  final List<Map> _period = [
    {"title": "За неделю", "type": ""},
    {"title": "За месяц", "type": ""},
    {"title": "За все время", "type": ""}
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250 + MediaQuery.of(context).padding.bottom,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Период"),
            actions: const [CloseIconButton(iconColor: null, padding: true)]),
        body: Column(
            children: _period.map((value) {
          return Container(
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 1, color: Color(0xfff4f5f7)))),
              child: ListTile(
                  onTap: () {
                    changedPeriod(value);
                    Navigator.pop(context);
                  },
                  title: Text(value['title'])));
        }).toList()),
      ),
    );
  }
}
