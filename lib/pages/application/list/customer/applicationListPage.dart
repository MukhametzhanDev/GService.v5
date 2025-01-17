import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/pages/application/item/applicationItem.dart';
import 'package:gservice5/pages/application/filter/filterApplicationListPage.dart';
import 'package:gservice5/pages/application/filter/filterApplicationWidget.dart';
import 'package:gservice5/pages/application/list/customer/emptyApplicationListPage.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ApplicationListPage extends StatefulWidget {
  const ApplicationListPage({super.key});

  @override
  State<ApplicationListPage> createState() => _ApplicationListPageState();
}

class _ApplicationListPageState extends State<ApplicationListPage> {
  List data = [];
  bool loader = true;
  ScrollController scrollController = ScrollController();
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  String title = "";
  Map<String, dynamic> param = {};

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
      Response response = await dio.get("/application", queryParameters: param);
      if (response.statusCode == 200 && response.data['success']) {
        print(response);
        data = response.data['data'];
        loader = false;
        hasNextPage = page != response.data['meta']['last_page'];
        setState(() {});

        await analytics.logViewItemList(
            itemListId: GAParams.applicationListId,
            itemListName: 'Заказы',
            parameters: {GAKey.isPagination: 'false'},
            items: data
                .map((item) => AnalyticsEventItem(
                        itemName: item?['title'],
                        itemId: item?['id']?.toString(),
                        itemCategory: item?['category']?['id']?.toString(),
                        parameters: {
                          'itemCategoryTitle': item?['category']?['title'],
                          GAKey.isPagination: 'false'
                        }))
                .toList());
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void loadMoreAd() async {
    if (scrollController.position.extentAfter < 100 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        Response response = await dio.get("/application",
            queryParameters: {"page": page.toString(), ...param});
        print(response.data);
        if (response.statusCode == 200 && response.data['success']) {
          data.addAll(response.data['data']);
          hasNextPage = page != response.data['meta']['last_page'];
          isLoadMore = false;
          setState(() {});

          await analytics.logViewItemList(
              parameters: {GAKey.isPagination: 'true'},
              itemListId: GAParams.applicationListId,
              itemListName: GAParams.applicationListName,
              items: data
                  .map((item) => AnalyticsEventItem(
                          itemName: item?['title'],
                          itemId: item?['id']?.toString(),
                          itemCategory: item?['category']?['id']?.toString(),
                          parameters: {
                            'itemCategoryTitle': item?['category']?['title'],
                            GAKey.isPagination: 'true'
                          }))
                  .toList());
        } else {
          SnackBarComponent().showResponseErrorMessage(response, context);
        }
      } catch (e) {
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    }
  }

  void onChanged(value) {
    print(value);
    if (value.isEmpty) {
      value = {};
    } else {
      param.addAll(value);
    }
    getData();
  }

  void showFilterPage() {
    showMaterialModalBottomSheet(
            context: context,
            enableDrag: false,
            builder: (context) => const FilterApplicationListPage())
        .then(filteredAds);
  }

  void filteredAds(value) {
    if (value != null) {
      param = FilterData.data;
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            FilterApplicationWidget(appBar: AppBar(), onChanged: filteredAds),
        body: loader
            ? const LoaderComponent()
            : data.isEmpty
                ? const EmptyApplicationListPage()
                : ListView.builder(
                    itemCount: data.length,
                    controller: scrollController,
                    itemBuilder: (context, int index) {
                      Map value = data[index];
                      if (data.length - 1 == index) {
                        return Column(children: [
                          ApplicationItem(data: value, showCategory: false),
                          hasNextPage
                              ? const PaginationLoaderComponent()
                              : Container()
                        ]);
                      } else {
                        return ApplicationItem(
                            data: value, showCategory: false);
                      }
                    }));
  }
}
