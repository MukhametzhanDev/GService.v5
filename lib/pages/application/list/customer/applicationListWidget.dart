import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/list/adListLoader.dart';
import 'package:gservice5/pages/application/item/applicationItem.dart';
import 'package:gservice5/pages/application/list/customer/emptyApplicationListPage.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ApplicationListWidget extends StatefulWidget {
  final Map<String, dynamic> param;
  final ScrollController scrollController;
  const ApplicationListWidget(
      {super.key, required this.param, required this.scrollController});

  @override
  State<ApplicationListWidget> createState() => _AdListWidgetState();
}

class _AdListWidgetState extends State<ApplicationListWidget>
    with AutomaticKeepAliveClientMixin {
  List data = [];
  bool loader = true;
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  String title = "";
  Map<String, dynamic> param = {};
  RefreshController refreshController = RefreshController();

  final analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    getData();
    param.addAll(widget.param);
    super.initState();
  }

  @override
  void dispose() {
    FilterData.data.clear();
    refreshController.dispose();
    super.dispose();
  }

  void showLoader() {
    if (!loader) {
      loader = true;
      setState(() {});
    }
  }

  Future getData() async {
    try {
      page = 1;
      Response response = await dio.get("/application", data: param);
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
        loader = false;
        hasNextPage = page != response.data['meta']['last_page'];
        setState(() {});

        await analytics.logViewItemList(
            parameters: {GAKey.isPagination: 'false'},
            itemListId: GAParams.bussinessAllApplicationListId,
            itemListName: GAParams.bussinessAllApplicationListName,
            items: data
                .map((toElement) => AnalyticsEventItem(
                    itemId: toElement?['id']?.toString(),
                    itemName: toElement['title']))
                .toList());
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    } finally {
      refreshController.refreshCompleted();
    }
  }

  void loadMoreAd() async {
    if (widget.scrollController.position.extentAfter < 100 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        Response response = await dio
            .get("/application", data: {"page": page.toString(), ...param});
        print(response.data);
        if (response.statusCode == 200) {
          data.addAll(response.data['data']);
          hasNextPage = page != response.data['meta']['last_page'];
          isLoadMore = false;
          setState(() {});

          await analytics.logViewItemList(
              parameters: {GAKey.isPagination: 'true'},
              itemListId: GAParams.bussinessAllApplicationListId,
              itemListName: GAParams.bussinessAllApplicationListName,
              items: data
                  .map((toElement) => AnalyticsEventItem(
                      itemId: toElement?['id']?.toString(),
                      itemName: toElement['title']))
                  .toList());
        } else {
          SnackBarComponent().showResponseErrorMessage(response, context);
        }
      } catch (e) {
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    }
  }

  void filteredAds(value) {
    if (value != null) {
      param = FilterData.data;
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return
        // appBar: FilterAdWidget(
        //     category: widget.category, appBar: AppBar(), onChanged: filteredAds),
        // AppBar(
        //   leadingWidth: MediaQuery.of(context).size.width - 100,
        //   actions: [
        //     FilterButton(showFilterPage: showFilterPage)
        //     // GestureDetector(
        //     //   onTap: () => showFilterPage(),
        //     //   child: Container(
        //     //     width: 36,
        //     //     height: 36,
        //     //     alignment: Alignment.center,
        //     //     margin: EdgeInsets.only(right: 15),
        //     //     decoration: BoxDecoration(
        //     //         borderRadius: BorderRadius.circular(8),
        //     //         color: ColorComponent.mainColor),
        //     //     child: SvgPicture.asset("assets/icons/filter.svg", width: 20),
        //     //   ),
        //     // )
        //   ],
        //   leading: BackTitleButton(
        //       title: widget.category['title'],
        //       onPressed: () => Navigator.pop(context)),
        //   bottom: PreferredSize(
        //       preferredSize: Size(double.infinity, 46),
        //       child: Container(
        //           decoration: BoxDecoration(
        //               border: Border(
        //                   bottom:
        //                       BorderSide(width: 2, color: Color(0xfff4f5f7)))),
        //           padding: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
        //           child: SortAdWidget(onChanged: onChanged))),
        // ),
        loader
            ? const AdListLoader()
            : SmartRefresher(
                onRefresh: () async => await getData(),
                enablePullDown: true,
                enablePullUp: false,
                controller: refreshController,
                header: MaterialClassicHeader(
                    color: ColorComponent.mainColor,
                    backgroundColor: Colors.white),
                child: data.isEmpty
                    ? const EmptyApplicationListPage()
                    : ListView.builder(
                        itemCount: data.length,
                        shrinkWrap: true,
                        // controller: scrollController,
                        itemBuilder: (context, int index) {
                          Map value = data[index];
                          if (data.length - 1 == index) {
                            return Column(children: [
                              ApplicationItem(data: value),
                              hasNextPage
                                  ? const PaginationLoaderComponent()
                                  : Container()
                            ]);
                          } else {
                            return ApplicationItem(data: value);
                          }
                        }));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
