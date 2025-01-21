import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/pages/ad/filter/filterAdAppBarWidget.dart';
import 'package:gservice5/pages/ad/item/adItem.dart';
import 'package:gservice5/pages/ad/list/adListLoader.dart';
import 'package:gservice5/pages/ad/list/emptyAdListPage.dart';
import 'package:gservice5/pages/create/application/createApplicationWidgetAdList.dart';
import 'package:gservice5/provider/adFilterProvider.dart';
import 'package:provider/provider.dart';

class AdListPage extends StatefulWidget {
  final Map category;
  const AdListPage({super.key, required this.category});

  @override
  State<AdListPage> createState() => _AdListPageState();
}

class _AdListPageState extends State<AdListPage> {
  List data = [];
  bool loader = true;
  ScrollController scrollController = ScrollController();
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  String title = "";

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
    Provider.of<AdFilterProvider>(context, listen: false)
        .changedCategory(widget.category['id']);
    try {
      page = 1;
      showLoader();
      Map<String, dynamic> param =
          Provider.of<AdFilterProvider>(context, listen: false).value;
      print("PARAM $param");
      Response response = await dio.get("/ad", queryParameters: param);
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
    if (scrollController.position.extentAfter < 100 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        Map<String, dynamic> param =
            Provider.of<AdFilterProvider>(context, listen: false).value;
        Response response = await dio
            .get("/ad", queryParameters: {"page": page.toString(), ...param});
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
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FilterAdAppBarWidget(
          category: widget.category, appBar: AppBar(), onChanged: filteredAds),
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
      body: loader
          ? const AdListLoader()
          : data.isEmpty
              ? const EmptyAdListPage()
              : ListView.builder(
                  itemCount: data.length,
                  controller: scrollController,
                  itemBuilder: (context, int index) {
                    Map value = data[index];
                    if (index % 20 == 0 && index > 19) {
                      return Column(children: [
                        AdItem(data: value),
                        const CreateApplicationWidgetAdList()
                      ]);
                    } else if (data.length - 1 == index) {
                      return Column(children: [
                        AdItem(data: value),
                        hasNextPage
                            ? const PaginationLoaderComponent()
                            : Container()
                      ]);
                    } else {
                      return Column(
                        children: [
                          AdItem(data: value),
                        ],
                      );
                    }
                  }),
    );
  }
}
