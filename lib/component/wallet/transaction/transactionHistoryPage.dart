import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/wallet/transaction/transactionItem.dart';
import 'package:sticky_headers/sticky_headers.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => TransactionHistoryPageState();
}

class TransactionHistoryPageState extends State<TransactionHistoryPage> {
  List _tabs = ["Все", "Ожидает", "Пополнения", "Оплата"];
  List<Map> sortData = [
    {"title": "За неделю"},
    {"title": "За месяц"},
    {"title": "За три месяца"},
    {"title": "За пол года"},
    {"title": "За год"},
    {"title": "За все время"},
  ];
  Map sortValue = {"title": "По умолчанию"};

  List<Map<String, dynamic>> transactions = [
    {
      "id": "123456789",
      "type": "Ожидает завершения",
      "date": "",
      "amount": "1 000 000 ₸",
      "bonus": "",
      "status": "pending"
    },
    {
      "id": "123456789",
      "type": "Оплата",
      "date": "15 Сентябрь 2024, 04:20",
      "amount": "- 1 000 000 ₸",
      "bonus": "100 000 бонус",
      "status": "completed"
    },
    {
      "id": "123456789",
      "type": "Пополнения",
      "date": "15 Сентябрь 2024, 05:00",
      "amount": "+ 1 000 000 ₸",
      "bonus": "100 000 бонус",
      "status": "completed"
    }
  ];

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
    for (var transaction in transactions) {
      final date = transaction['date']?.split(',')[0] ?? "Без даты";
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }

    return DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
            appBar: AppBar(
                leadingWidth: MediaQuery.of(context).size.width - 200,
                leading: BackTitleButton(
                    title: "История транзакций",
                    onPressed: () => Navigator.pop(context)),
                centerTitle: false,
                bottom: PreferredSize(
                    preferredSize: Size(MediaQuery.of(context).size.width, 44),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 2, color: Color(0xfff4f5f7)))),
                      child: TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: Colors.black,
                          unselectedLabelColor: ColorComponent.gray['500'],
                          tabs: _tabs.map((value) {
                            return Tab(child: Text(value));
                          }).toList()),
                    )),
                actions: <Widget>[
                  PopupMenuButton<Map>(
                      icon: Row(children: [
                        Text(sortValue['title'],
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: ColorComponent.blue['500'])),
                        SizedBox(width: 4),
                        SvgPicture.asset('assets/icons/sort.svg')
                      ]),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 1,
                      popUpAnimationStyle: AnimationStyle(curve: Curves.linear),
                      initialValue: sortValue,
                      menuPadding: EdgeInsets.all(0),
                      itemBuilder: (BuildContext context) {
                        return sortData.map((value) {
                          return PopupMenuItem<Map>(
                              onTap: () {
                                sortValue = value;
                                setState(() {});
                              },
                              child: Text(value['title']));
                        }).toList();
                      })
                ]),
            body: TabBarView(
                children: _tabs.map((value) {
              return ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return StickyHeader(
                        header: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xfff4f5f7)))),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text("15 Сентябрь 2024",
                                style: TextStyle(fontWeight: FontWeight.w600))),
                        content: Column(
                            children: List.generate(6, (index) {
                          return TransactionItem();
                        }).toList()));
                  });
            }).toList())));
  }
}