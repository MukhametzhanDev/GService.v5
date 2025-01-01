import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/pages/ad/item/adItem.dart';
import 'package:gservice5/pages/ad/list/adListLoader.dart';
import 'package:gservice5/pages/ad/list/emptyAdListPage.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/profile/news/newsItem.dart';

class NewsList extends StatefulWidget {
  final Map<String, dynamic> param;
  final ScrollController scrollController;
  const NewsList(
      {super.key, required this.param, required this.scrollController});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList>
    with AutomaticKeepAliveClientMixin {
  List data = [];
  bool loader = true;
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  String title = "";
  Map<String, dynamic> param = {};

  @override
  void initState() {
    getData();
    param.addAll(widget.param);
    super.initState();
  }

  @override
  void dispose() {
    FilterData.data.clear();
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
      showLoader();
      Response response = await dio.get("/ad", data: param);
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
    if (widget.scrollController.position.extentAfter < 100 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        Response response =
            await dio.get("/ad", data: {"page": page.toString(), ...param});
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

  void filteredAds(value) {
    if (value != null) {
      param = FilterData.data;
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return loader
        ? const AdListLoader()
        : data.isEmpty
            ? const EmptyAdListPage()
            : ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // controller: scrollController,
                itemBuilder: (context, int index) {
                  Map value = data[index];
                  if (data.length - 1 == index) {
                    return Column(children: [
                      NewsItem(data: value),
                      hasNextPage
                          ? const PaginationLoaderComponent()
                          : Container()
                    ]);
                  } else {
                    return NewsItem(data: value);
                  }
                });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
