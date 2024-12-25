import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/filter/filterAdWidget.dart';
import 'package:gservice5/pages/ad/item/adItem.dart';
import 'package:gservice5/pages/ad/list/adListLoader.dart';
import 'package:gservice5/pages/ad/list/emptyAdListPage.dart';
import 'package:gservice5/pages/create/application/sectionCreateApplicationPage.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
  Map<String, dynamic> param = {};

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
      print(param);
      Response response = await dio.get("/ad",
          queryParameters: {...param, "category_id": widget.category['id']});
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
        setState(() {});
        Response response = await dio.get("/ad", queryParameters: {
          "page": page.toString(),
          ...param,
          "category_id": widget.category['id']
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

  void filteredAds(value) {
    if (value != null) {
      param = FilterData.data;
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FilterAdWidget(
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
                    if (index % 9 == 0 && index > 8) {
                      return Column(children: [
                        AdItem(data: value, showCategory: false),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 6, color: Color(0xfff4f5f7)))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Оставьте заказ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                              Divider(indent: 6),
                              Text(
                                  "Если вы не нашли или трудно найти спецтехнику, вы можете разместить заказ. Ваш заказ будет показано на официальных диллерах",
                                  style: TextStyle(
                                      color: ColorComponent.gray['600']),
                                  textAlign: TextAlign.center),
                              Divider(indent: 6),
                              SizedBox(
                                height: 38,
                                child: Button(
                                    onPressed: () {
                                      showCupertinoModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              SectionCreateApplicationPage());
                                    },
                                    title: "Разместить заказ"),
                              )
                            ],
                          ),
                        )
                      ]);
                    } else if (data.length - 1 == index) {
                      return Column(children: [
                        AdItem(data: value, showCategory: false),
                        hasNextPage
                            ? const PaginationLoaderComponent()
                            : Container()
                      ]);
                    } else {
                      return Column(
                        children: [
                        Text(index.toString()),
                          AdItem(data: value, showCategory: false),
                        ],
                      );
                    }
                  }),
    );
  }
}
