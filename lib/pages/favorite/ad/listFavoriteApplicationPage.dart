import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/application/item/applicationItem.dart';
import 'package:gservice5/pages/favorite/ad/emptyFavoriteListPage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListFavoriteApplicationPage extends StatefulWidget {
  const ListFavoriteApplicationPage({super.key});

  @override
  State<ListFavoriteApplicationPage> createState() =>
      _ListFavoriteApplicationPageState();
}

class _ListFavoriteApplicationPageState
    extends State<ListFavoriteApplicationPage> {
  List data = [];
  bool loader = true;
  ScrollController scrollController = ScrollController();
  bool hasNextPage = false;
  bool isLoadMore = false;
  RefreshController refreshController = RefreshController();
  int page = 1;

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
      Response response = await dio.get("/my-favorites",
          queryParameters: {"favoritable_type": "application"});
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
        loader = false;
        hasNextPage = page != response.data['meta']['last_page'];
        setState(() {});
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
          "favoritable_type": "application"
        });
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
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          // bottom: PreferredSize(
          //     preferredSize: Size(double.infinity, 48), child: Row(children: [])),
        ),
        body: loader
            ? const LoaderComponent()
            : data.isEmpty
                ? const EmptyFavoriteListPage()
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
                        child: ListView.builder(
                            itemCount: data.length,
                            controller: scrollController,
                            itemBuilder: (context, int index) {
                              Map value = data[index];
                              if (data.length - 1 == index) {
                                return Column(children: [
                                  ApplicationItem(
                                      data: value['favoritable'],
                                      showCategory: false),
                                  hasNextPage
                                      ? const PaginationLoaderComponent()
                                      : Container()
                                ]);
                              } else {
                                return ApplicationItem(
                                    data: value['favoritable'],
                                    showCategory: false);
                              }
                            }),
                      ))
                    ],
                  ));
  }
}
