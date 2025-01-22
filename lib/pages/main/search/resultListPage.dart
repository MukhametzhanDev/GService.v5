import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/pages/ad/item/adItem.dart';
import 'package:gservice5/pages/application/item/applicationItem.dart';

class ResultListPage extends StatefulWidget {
  final Map<String, dynamic> param;
  final List data;
  const ResultListPage({super.key, required this.data, required this.param});

  @override
  State<ResultListPage> createState() => _ResultListPageState();
}

class _ResultListPageState extends State<ResultListPage> {
  List data = [];
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  ScrollController scrollController = ScrollController();

  final analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    data = widget.data;
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

  void loadMoreAd() async {
    if (scrollController.position.extentAfter < 100 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        Response response = await dio.get("/search", queryParameters: {
          "page": page.toString(),
          ...widget.param,
          "per_page": 15
        });
        print(response.data);
        if (response.statusCode == 200) {
          data.addAll(response.data['data']);
          hasNextPage = page != response.data['meta']['last_page'];
          isLoadMore = false;
          setState(() {});

          await analytics.logViewItemList(
              parameters: {GAKey.isPagination: "true"},
              itemListId: GAParams.listSeachMainId,
              itemListName: GAParams.listSeachMainName,
              items: data
                  .map((toElement) => AnalyticsEventItem(
                      itemId: toElement['id'].toString(),
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

  Widget getItem(Map value) {
    if (widget.param['category_id'] == 3) {
      return ApplicationItem(data: value);
    } else {
      return AdItem(data: value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.param.isNotEmpty
            ? Container()
            : const Padding(
                padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: Text("Спецтехники по Казахстану",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600, height: 1)),
              ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            controller: scrollController,
            itemCount: data.length,
            itemBuilder: (context, int index) {
              Map value = data[index];
              if (data.length - 1 == index) {
                return Column(children: [
                  getItem(value),
                  hasNextPage ? const PaginationLoaderComponent() : Container()
                ]);
              } else {
                return getItem(value);
              }
            }),
      ],
    );
  }
}
