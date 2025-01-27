import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/profile/news/empty/emptyNewsPage.dart';
import 'package:gservice5/pages/profile/news/newsItem.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class AllNewsPage extends StatefulWidget {
  final bool? showBackButton;
  const AllNewsPage({super.key, this.showBackButton});

  @override
  State<AllNewsPage> createState() => _AllNewsPageState();
}

class _AllNewsPageState extends State<AllNewsPage> {
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
      Response response = await dio.get("/news");
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
        Response response =
            await dio.get("/news", queryParameters: {"page": page.toString()});
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
      appBar: widget.showBackButton ?? false
          ? AppBar(
              leading:  BackTitleButton(title: context.localizations.news),
              leadingWidth: 200)
          : null,
      body: loader
          ? const LoaderComponent()
          : SmartRefresher(
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
                  ? const EmptyNewsPage()
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return NewsItem(data: data[index]);
                      }),
            ),
    );
  }
}
