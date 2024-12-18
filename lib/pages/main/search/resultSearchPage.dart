import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/list/adListLoader.dart';
import 'package:gservice5/pages/ad/list/emptyAdListPage.dart';
import 'package:gservice5/pages/main/adListMain.dart';
import 'package:gservice5/pages/main/search/resultListPage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class ResultSearchPage extends StatefulWidget {
  final String title;
  const ResultSearchPage({super.key, required this.title});

  @override
  State<ResultSearchPage> createState() => _ResultSearchPageState();
}

class _ResultSearchPageState extends State<ResultSearchPage> {
  List count = [];
  bool loader = true;
  bool loaderAd = true;
  int currentIndex = 0;
  RefreshController refreshController = RefreshController();
  List data = [];

  @override
  void initState() {
    getDataCountAd();
    super.initState();
  }

  Future getDataCountAd() async {
    if (count.isNotEmpty) {
      try {
        Response response = await dio
            .get("/search-count", queryParameters: {"title": widget.title});
        if (response.statusCode == 200 && response.data['success']) {
          count = formattedData(response.data['data']);
          loader = false;
          setState(() {});
          getResultAd();
        } else {
          SnackBarComponent().showResponseErrorMessage(response, context);
        }
      } catch (e) {
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    } else {
      loader = false;
      loaderAd = false;
      setState(() {});
    }
  }

  void showLoader() {
    if (!loaderAd) {
      setState(() {
        loaderAd = true;
      });
    }
  }

  Future getResultAd() async {
    showLoader();
    try {
      Response response = await dio.get("/search", queryParameters: {
        "title": widget.title,
        "category_id": count[currentIndex]['id'],
        "per_page": 15
      });
      if (response.statusCode == 200 && response.data['success']) {
        data = response.data['data'];
        loaderAd = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  List formattedData(List value) {
    return value.where((value) => value['count'] != 0).toList();
  }

  void onChangedIndex(int index) {
    setState(() {
      currentIndex = index;
    });
    getResultAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          shape: Border(
              bottom: BorderSide(
                  color: Color(0xfff4f5f7), width: count.isEmpty ? 0 : 1)),
          leadingWidth: 0,
          title: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                Container(
                    width: 30,
                    alignment: Alignment.center,
                    child:
                        SvgPicture.asset('assets/icons/left.svg', width: 26)),
                Divider(indent: 4),
                SvgPicture.asset("assets/icons/searchOutline.svg",
                    color: ColorComponent.gray['500']),
                Divider(indent: 6),
                Text(widget.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
              ],
            ),
          ),
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 46),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    loader
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                                children: List.generate(3, (index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, bottom: 10),
                                child: Shimmer.fromColors(
                                    baseColor: Color(0xffD1D5DB),
                                    highlightColor: Color(0xfff4f5f7),
                                    period: Duration(seconds: 1),
                                    child: Container(
                                        width: 100,
                                        height: 36,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8)))),
                              );
                            })),
                          )
                        : count.isEmpty
                            ? Container()
                            : SingleChildScrollView(
                                padding: EdgeInsets.only(
                                    left: 12, right: 12, bottom: 10),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: count.map((value) {
                                  int index = count.indexOf(value);
                                  return GestureDetector(
                                    onTap: () {
                                      onChangedIndex(index);
                                    },
                                    child: Container(
                                      height: 36,
                                      decoration: BoxDecoration(
                                          color: index == currentIndex
                                              ? ColorComponent.mainColor
                                              : ColorComponent.mainColor
                                                  .withOpacity(.15),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      alignment: Alignment.center,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      padding:
                                          EdgeInsets.only(left: 16, right: 12),
                                      child: Row(
                                        children: [
                                          Text(value['title'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          Container(
                                            margin: EdgeInsets.only(left: 6),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4),
                                            decoration: BoxDecoration(
                                                color:
                                                    ColorComponent.red['500'],
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Text(
                                                numberFormat(value['count']),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white)),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList()),
                              ),
                    // Divider(height: 2),
                    // Padding(
                    //   padding:
                    //       const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    //   child: Row(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         // SortAdWidget(onChanged: (value) {}),
                    //         Row(children: [
                    //           GestureDetector(
                    //             child: Container(
                    //               width: 36,
                    //               height: 36,
                    //               alignment: Alignment.center,
                    //               decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(8),
                    //                   color: ColorComponent.mainColor),
                    //               child: SvgPicture.asset("assets/icons/sort.svg",
                    //                   width: 20, color: Colors.black),
                    //             ),
                    //           ),
                    //           Divider(indent: 12),
                    //           GestureDetector(
                    //             child: Container(
                    //               width: 36,
                    //               height: 36,
                    //               alignment: Alignment.center,
                    //               decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(8),
                    //                   color: ColorComponent.mainColor),
                    //               child: SvgPicture.asset("assets/icons/filter.svg",
                    //                   width: 20),
                    //             ),
                    //           )
                    //         ])
                    //       ]),
                    // )
                  ],
                ),
              )),
        ),
        body: loader
            ? LoaderComponent()
            : count.isEmpty
                ? EmptyAdListPage()
                : loaderAd
                    ? AdListLoader()
                    : SingleChildScrollView(
                        child: ResultListPage(data: data, param: {
                          "title": widget.title,
                          "category_id": count[currentIndex]['id']
                        }),
                      ));
  }
}
