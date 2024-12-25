import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/application/my/emptyMyApplicationPage.dart';
import 'package:gservice5/pages/application/my/myApplicationItem.dart';
import 'package:gservice5/pages/application/my/viewMyApplicationPage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyApplicationListPage extends StatefulWidget {
  const MyApplicationListPage({super.key});

  @override
  State<MyApplicationListPage> createState() => _MyApplicationListPageState();
}

class _MyApplicationListPageState extends State<MyApplicationListPage> {
  final List _tabs = [
    {"title": "Активные", "type": "pending", "count": ""},
    {"title": "Удаленное", "type": "canceled", "count": ""},
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

  @override
  void initState() {
    getCount();
    getData();
    super.initState();
    scrollController.addListener(() => loadMoreAd());
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    refreshController.dispose();
  }

  Future getCount() async {
    try {
      String? token = await ChangedToken().getToken();
      Response response = await dio.get("/my-applications-status-count",
          options: Options(headers: {"authorization": "Bearer $token"}));
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
    refreshController.refreshCompleted();
  }

  Future getData() async {
    try {
      page = 1;
      setState(() {});
      String? token = await ChangedToken().getToken();
      print(token);
      Response response = await dio.get("/my-applications",
          queryParameters: {"status": currentStatusAd},
          options: Options(headers: {"authorization": "Bearer $token"}));
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
  }

  Future loadMoreAd() async {
    if (scrollController.position.extentAfter < 200 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        String? token = await ChangedToken().getToken();
        Map<String, dynamic> parameter = {
          "page": page,
          "status": currentStatusAd
        };
        Response response = await dio.get("/my-applications",
            queryParameters: parameter,
            options: Options(headers: {"authorization": "Bearer $token"}));
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
      if (value == "delete") {
        updateData(id);
      }
    });
  }

  void updateData(int id) {
    data.removeWhere((item) => item['id'] == id);
    getCount();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackIconButton(),
          title: const Text("Мои заказы"),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 50),
            child: Container(
              height: 52,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 2, color: Color(0xfff4f5f7)))),
              padding: const EdgeInsets.only(left: 6, right: 6),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  children: _tabs.map((value) {
                    return TabButton(value);
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        body: loader
            ? const LoaderComponent()
            : SmartRefresher(
                onRefresh: () async {
                  await getCount();
                  await getData();
                },
                enablePullDown: true,
                enablePullUp: false,
                controller: refreshController,
                header: MaterialClassicHeader(
                    color: ColorComponent.mainColor,
                    backgroundColor: Colors.white),
                child: data.isEmpty
                    ? const EmptyMyApplicationPage()
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          Map item = data[index];
                          if (index == data.length - 1) {
                            return Column(children: [
                              MyApplicationItem(
                                  onPressed: showMyApplicationPage,
                                  data: item,
                                  removeItem: updateData,
                                  restoreItem: updateData),
                              isLoadMore
                                  ? const PaginationLoaderComponent()
                                  : Container()
                            ]);
                          } else {
                            return MyApplicationItem(
                                onPressed: showMyApplicationPage,
                                data: item,
                                removeItem: updateData,
                                restoreItem: updateData);
                          }
                        },
                      )));
  }

  GestureDetector TabButton(Map value) {
    bool active = value['type'] != currentStatusAd;
    return GestureDetector(
        onTap: () {
          currentStatusAd = value['type'];
          loader = true;
          setState(() {});
          getData();
        },
        child: Container(
          height: 36,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: !active ? ColorComponent.mainColor : Colors.white),
          padding: const EdgeInsets.only(left: 16, right: 8, top: 6, bottom: 6),
          margin: const EdgeInsets.only(right: 8),
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value['title'],
                  style: TextStyle(
                      fontSize: 13,
                      color:
                          active ? ColorComponent.gray['700'] : Colors.black)),
              const Divider(indent: 8),
              Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: active
                          ? ColorComponent.mainColor.withOpacity(.2)
                          : ColorComponent.mainColor),
                  child: Text(
                    value['count'],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ))
            ],
          ),
        ));
  }
}
