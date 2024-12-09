import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/my/myAdEmptyPage.dart';
import 'package:gservice5/pages/ad/my/myAdItem.dart';
import 'package:gservice5/pages/ad/my/optionsMyAdModal.dart';
import 'package:gservice5/pages/ad/my/request/myAdRequest.dart';
import 'package:gservice5/pages/ad/my/viewMyAdPage.dart';
import 'package:gservice5/pages/ad/package/listPackagePage.dart';
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
  String role = "";

  @override
  void initState() {
    getCount();
    getData();
    super.initState();
    scrollController.addListener(() => loadMoreAd());
    tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        currentStatusAd = tabController.index == 0
            ? "pending"
            : tabController.index == 1
                ? "archived"
                : "deleted";
        loader = true;
        setState(() {});
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
    try {
      Response response = await dio.get("/my-ads-status-count");
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
    role = await ChangedToken().getRole();
    try {
      page = 1;
      setState(() {});
      Response response = await dio
          .get("/my-ads", queryParameters: {"status": currentStatusAd});
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

  void showOptions(Map<String, dynamic> data) async {
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
                  OptionsMyAdModal(data: data, status: data['status']))
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
                )),
          ),
          body: TabBarView(
              controller: tabController,
              children: List.generate(
                  3, (index) => loader ? LoaderComponent() : ListMyAds()))),
    );
  }

  void showPage(int id) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => ViewMyAdPage(id: id)))
        .then((value) {
      if (value == "update") {
        updateData(id);
      }
    });
  }

  void showListPromotionPage(Map value) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ListPackagePage(rubricId: 0, adId: value['id'], goBack: true)));
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
                  Map<String, dynamic> item = data[index];
                  return MyAdItem(
                      data: item,
                      onPressed: showPage,
                      role: role,
                      showOptions: showOptions,
                      showListPromotionPage: showListPromotionPage);
                },
                // )
              );
  }

  Tab TopTabButton(Map value) {
    return Tab(
        child: Row(children: [
      Text(value['title']),
      Container(
        width: 20,
        height: 20,
        margin: EdgeInsets.only(left: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorComponent.mainColor.withOpacity(.1)),
        child: Text(
          value['count'],
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      )
    ]));
  }
}
