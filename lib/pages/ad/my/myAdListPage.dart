import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/my/myAdEmptyPage.dart';
import 'package:gservice5/pages/ad/my/myAdItem.dart';
import 'package:gservice5/pages/ad/my/optionsMyAdPageModal.dart';
import 'package:gservice5/pages/ad/my/request/myAdRequest.dart';
import 'package:gservice5/pages/ad/my/viewMyAdPage.dart';
import 'package:gservice5/pages/application/my/viewMyApplicationPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyAdListPage extends StatefulWidget {
  const MyAdListPage({super.key});

  @override
  State<MyAdListPage> createState() => _MyAdListPageState();
}

class _MyAdListPageState extends State<MyAdListPage>
    with SingleTickerProviderStateMixin {
  final List _tabs = [
    {"title": "Активные", "type": "pending", "count": ""},
    {"title": "В архвие", "type": "archived", "count": ""},
    {"title": "Удаленное", "type": "deleted", "count": ""},
    // {"title": "Отклоненные"},
  ];
  int tabIndex = 1;
  List data = [];
  bool loader = true;
  String currentStatusAd = "pending";
  ScrollController scrollController = ScrollController();
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  RefreshController refreshController = RefreshController();
  late TabController tabController;

  @override
  void initState() {
    getCount();
    getData();
    super.initState();
    scrollController.addListener(() => loadMoreAd());
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      currentStatusAd = tabController.index == 0
          ? "pending"
          : tabController.index == 1
              ? "archived"
              : "deleted";
      loader = true;
      getData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    refreshController.dispose();
  }

  Future getCount() async {
    print("AKLSDAKSD");
    try {
      Response response = await dio.get("/my-ads-status-count");
      print(response.data);
      if (response.data['success']) {
        Map data = response.data['data'];
        for (var value in _tabs) {
          value['count'] = data[value['type']].toString();
        }
        setState(() {});
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  Future getData() async {
    try {
      page = 1;
      setState(() {});
      Response response = await dio
          .get("/my-ads", queryParameters: {"status": currentStatusAd});
      print(response.data);
      if (response.data['success']) {
        data = response.data['data'];
        hasNextPage = page != response.data['meta']['last_page'];
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
    refreshController.refreshCompleted();
  }

  Future loadMoreAd() async {
    if (scrollController.position.extentAfter < 200 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        Map<String, dynamic> parameter = {
          "page": page,
          "status": currentStatusAd
        };
        Response response =
            await dio.get("/my-ads", queryParameters: parameter);
        print(response.data);
        if (response.data['success']) {
          data.addAll(response.data['data']);
          hasNextPage = page != response.data['meta']['last_page'];
          isLoadMore = false;
          setState(() {});
        } else {
          SnackBarComponent()
              .showErrorMessage(response.data['message'], context);
        }
      } catch (e) {
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    }
  }

  void showMyApplicationPage(int id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewMyApplicationPage(id: id))).then((value) {
      if (value == "delete") updateData(id);
    });
  }

  void updateData(int id) async {
    final index = data.indexWhere((item) => item['id'] == id);
    await getCount();
    setState(() {
      data.removeAt(index);
    });
  }

  void showOptions(Map data) async {
    if (data['status'] == "deleted") {
      if (await MyAdRequest().restoreAd(data['id'], context)) {
        updateData(data['id']);
      }
    } else if (data['status'] == "archived") {
      if (await MyAdRequest().unZipAd(data['id'], context)) {
        updateData(data['id']);
      }
    } else {
      showCupertinoModalBottomSheet(
              context: context,
              builder: (context) =>
                  OptionsMyAdPageModal(data: data, status: data['status']))
          .then((value) {
        if (value == "update") {
          updateData(data['id']);
        } else if (value == "edit") {
          refreshController.requestRefresh();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            leading: BackIconButton(),
            title: Text("Мои объялвения"),
            elevation: 0,
            bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 50),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 2, color: Color(0xffe5e7eb)))),
                  child: TabBar(
                      controller: tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 3,
                      tabs: _tabs.map((value) {
                        return TopTabButton(value);
                      }).toList()),
                )
                // Container(
                //   height: 52,
                //   decoration: BoxDecoration(
                //       border: Border(
                //           bottom: BorderSide(width: 1, color: Color(0xffE5E7EB)))),
                //   padding: const EdgeInsets.only(left: 6, right: 6),
                //   child: SingleChildScrollView(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                //     child: Row(
                //       children: _tabs.map((value) {
                //         return TabButton(value);
                //       }).toList(),
                //     ),
                //   ),
                // ),
                ),
          ),
          body: TabBarView(
              controller: tabController,
              children: List.generate(
                  3, (index) => loader ? LoaderComponent() : ListMyAds()))),
    );
  }

  Widget ListMyAds() {
    return
        // SmartRefresher(
        //     onRefresh: () async {
        //       await getCount();
        //       await getData();
        //     },
        //     enablePullDown: true,
        //     enablePullUp: false,
        //     controller: refreshController,
        //     header: MaterialClassicHeader(
        //         color: ColorComponent.mainColor, backgroundColor: Colors.white),
        //     child:

        data.isEmpty
            ? MyAdEmptyPage()
            : ListView.builder(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
                controller: scrollController,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  Map item = data[index];
                  return MyAdItem(
                      data: item,
                      onPressed: (id) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewMyAdPage(id: id)));
                      },
                      showOptions: showOptions,
                      showListPromotionPage: (value) {});
                },
                // )
              );
  }

  Tab TopTabButton(Map value) {
    return Tab(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value['title'], style: TextStyle(color: Colors.black)),
          Divider(indent: 8),
          Container(
              height: 24,
              constraints: BoxConstraints(minWidth: 24),
              padding: EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorComponent.mainColor.withOpacity(.2)),
              child: Text(
                value['count'],
                style: TextStyle(color: Colors.black, fontSize: 12),
              ))
        ],
      ),
      // text: "Активные"
    );
  }
}
