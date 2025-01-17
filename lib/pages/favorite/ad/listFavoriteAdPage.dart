import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/item/adItem.dart';
import 'package:gservice5/pages/favorite/ad/emptyFavoriteListPage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListFavoriteAdPage extends StatefulWidget {
  const ListFavoriteAdPage({super.key});

  @override
  State<ListFavoriteAdPage> createState() => _ListFavoriteAdPageState();
}

class _ListFavoriteAdPageState extends State<ListFavoriteAdPage> {
  List data = [];
  bool loader = true;
  ScrollController scrollController = ScrollController();
  bool hasNextPage = false;
  bool isLoadMore = false;
  RefreshController refreshController = RefreshController();
  int page = 1;

  final analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    getData();
    scrollController.addListener(() {
      loadMoreAd();
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future getData() async {
    try {
      page = 1;
      setState(() {});
      Response response = await dio
          .get("/my-favorites", queryParameters: {"favoritable_type": "ad"});
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
        loader = false;
        hasNextPage = page != response.data['meta']['last_page'];
        setState(() {});

        await analytics.logViewItemList(
            parameters: {GAKey.isPagination: 'false'},
            itemListId: GAParams.listFavoriteAdPageListId,
            itemListName: GAParams.listFavoriteAdPageListName,
            items: data
                .map((toElement) => AnalyticsEventItem(
                    itemId: toElement['id'].toString(),
                    itemName: toElement?['favoritable']?['title']))
                .toList());
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
    refreshController.refreshCompleted();
  }

  void loadMoreAd() async {
    if (scrollController.position.extentAfter < 100 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        Response response = await dio.get("/my-favorites", queryParameters: {
          "page": page.toString(),
          "favoritable_type": "ad"
        });
        print(response.data);
        if (response.statusCode == 200) {
          data.addAll(response.data['data']);
          hasNextPage = page != response.data['meta']['last_page'];
          isLoadMore = false;
          setState(() {});

          List pagData = response.data['data'];

          await analytics.logViewItemList(
              parameters: {GAKey.isPagination: 'true'},
              itemListId: GAParams.listFavoriteAdPageListId,
              itemListName: GAParams.listFavoriteAdPageListName,
              items: pagData
                  .map((toElement) => AnalyticsEventItem(
                      itemId: toElement['id'].toString(),
                      itemName: toElement?['favoritable']?['title']))
                  .toList());
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
    return Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: loader
            ? const LoaderComponent()
            : Column(
                children: [
                  Expanded(
                      child: SmartRefresher(
                    onRefresh: () async {
                      await getData();
                    },
                    enablePullDown: true,
                    enablePullUp: false,
                    controller: refreshController,
                    header: MaterialClassicHeader(
                        color: ColorComponent.mainColor,
                        backgroundColor: Colors.white),
                    child: data.isEmpty
                        ? const EmptyFavoriteListPage()
                        : ListView.builder(
                            itemCount: data.length,
                            controller: scrollController,
                            itemBuilder: (context, int index) {
                              Map value = data[index];
                              if (data.length - 1 == index) {
                                return Column(children: [
                                  AdItem(
                                    data: value['favoritable'],
                                    showCategory: false,
                                    fromPage: GAParams.listFavoriteAdPage,
                                  ),
                                  hasNextPage
                                      ? const PaginationLoaderComponent()
                                      : Container()
                                ]);
                              } else {
                                return AdItem(
                                    fromPage: GAParams.listFavoriteAdPage,
                                    data: value['favoritable'],
                                    showCategory: false);
                              }
                            }),
                  ))
                ],
              ));
  }
}
