import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/application/my/myApplicationItem.dart';
import 'package:gservice5/pages/application/my/viewMyApplicationPage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyApplicationListPage extends StatefulWidget {
  final RefreshController refreshController;
  final bool showAppBar;
  const MyApplicationListPage(
      {super.key, required this.refreshController, required this.showAppBar});

  @override
  State<MyApplicationListPage> createState() => _MyApplicationListPageState();
}

class _MyApplicationListPageState extends State<MyApplicationListPage>
    with AutomaticKeepAliveClientMixin {
  final List _tabs = [
    {"title": "Активные", "type": "pending", "count": ""},
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
    widget.refreshController.dispose();
    scrollController.dispose();
  }

  Future getCount() async {
    try {
      String? token = await FlutterSecureStorage().read(key: "token");
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
  }

  Future getData() async {
    try {
      page = 1;
      setState(() {});
      String? token = await FlutterSecureStorage().read(key: "token");
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
    widget.refreshController.refreshCompleted();
  }

  Future loadMoreAd() async {
    if (scrollController.position.extentAfter < 200 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        String? token = await FlutterSecureStorage().read(key: "token");
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
      if (value == "delete") updateData(id);
    });
  }

  void updateData(int id) {
    // getCount();
    for (int i = 0; i < data.length; i++) {
      if (data[i]['id'] == id) {
        setState(() {
          data.removeAt(i);
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          leading: widget.showAppBar ? BackIconButton() : null,
          title: widget.showAppBar ? Text("Мои заявки") : null,
          toolbarHeight: widget.showAppBar ? null : 4,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 50),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xffE5E7EB)))),
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
            ? LoaderComponent()
            : SmartRefresher(
                onRefresh: () async {
                  // await getCount();
                  await getData();
                },
                enablePullDown: true,
                enablePullUp: false,
                controller: widget.refreshController,
                header: MaterialClassicHeader(
                    color: ColorComponent.mainColor,
                    backgroundColor: Colors.white),
                child:
                    // data.isEmpty
                    // ? Align(alignment: Alignment.center, child: EmptyMyAdPage())
                    // :
                    ListView.builder(
                  controller: scrollController,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    Map item = data[index];
                    if (index == data.length - 1) {
                      return Column(children: [
                        MyApplicationItem(
                            onPressed: showMyApplicationPage, data: item),
                        isLoadMore ? PaginationLoaderComponent() : Container()
                      ]);
                    } else {
                      return MyApplicationItem(
                          onPressed: showMyApplicationPage, data: item);
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
          padding: EdgeInsets.only(left: 16, right: 8, top: 6, bottom: 6),
          margin: EdgeInsets.only(right: 8),
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
              Divider(indent: 8),
              Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: active
                          ? ColorComponent.mainColor.withOpacity(.2)
                          : ColorComponent.mainColor),
                  child: Text(value['count']))
            ],
          ),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}