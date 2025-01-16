import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/payment/transaction/transactionItem.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => TransactionHistoryPageState();
}

class TransactionHistoryPageState extends State<TransactionHistoryPage>
    with SingleTickerProviderStateMixin {
  final List _tabs = ["Все", "Ожидает", "Пополнения", "Оплата"];
  List<Map> sortData = [
    {"title": "За неделю"},
    {"title": "За месяц"},
    {"title": "За три месяца"},
    {"title": "За пол года"},
    {"title": "За год"},
    {"title": "За все время"},
  ];
  Map sortValue = {"title": "По умолчанию"};
  List data = [];
  ScrollController scrollController = ScrollController();
  late TabController tabController;
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  bool loader = true;
  String status = "";

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    // tabController.addListener(() {
    //   // canceled/pending/success
    //   if (tabController.index == 1) {
    //     status = "pending";
    //   } else if (tabController.index == 2) {

    //   }
    // });
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      page = 1;
      Response response = await dio
          .get("/payment-transactions", queryParameters: {"status": status});
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
        loader = false;
        hasNextPage = page != response.data['meta']['last_page'];
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void loadMoreAd() async {
    if (scrollController.position.extentAfter < 100 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        Response response = await dio.get("/payment-transactions",
            queryParameters: {"page": page.toString(), "status": status});
        print(response.data);
        if (response.statusCode == 200) {
          data.addAll(response.data['data']);
          hasNextPage = page != response.data['meta']['last_page'];
          isLoadMore = false;
          setState(() {});
        } else {
          SnackBarComponent().showResponseErrorMessage(response, context);
        }
      } catch (e) {
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    decoration: const BoxDecoration(
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
              // actions: <Widget>[
              //   PopupMenuButton<Map>(
              //       icon: Row(children: [
              //         Text(sortValue['title'],
              //             style: TextStyle(
              //                 fontWeight: FontWeight.w500,
              //                 color: ColorComponent.blue['500'])),
              //         const SizedBox(width: 4),
              //         SvgPicture.asset('assets/icons/sort.svg')
              //       ]),
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8)),
              //       elevation: 1,
              //       popUpAnimationStyle: AnimationStyle(curve: Curves.linear),
              //       initialValue: sortValue,
              //       menuPadding: const EdgeInsets.all(0),
              //       itemBuilder: (BuildContext context) {
              //         return sortData.map((value) {
              //           return PopupMenuItem<Map>(
              //               onTap: () {
              //                 sortValue = value;
              //                 setState(() {});
              //               },
              //               child: Text(value['title']));
              //         }).toList();
              //       })
              // ]
            ),
            body: TabBarView(
                children: _tabs.map((element) {
              return loader
                  ? const LoaderComponent()
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        Map value = data[index];
                        List payments = value['payments'];
                        return StickyHeader(
                            header: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: Color(0xfff4f5f7)))),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Text(formattedISODate(value['date']),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600))),
                            content: Column(
                                children: payments.map((paymentData) {
                              return TransactionItem(data: paymentData);
                            }).toList()));
                      });
            }).toList())));
  }
}

String formattedISODate(String isoDate) {
  DateTime parsedDate = DateTime.parse(isoDate);
  String formattedDate = DateFormat('dd MMMM yyyy', 'ru').format(parsedDate);
  return formattedDate;
}
