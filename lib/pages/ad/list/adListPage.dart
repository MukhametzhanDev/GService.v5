import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/item/adItem.dart';
import 'package:gservice5/pages/ad/widget/sortAdWidget.dart';

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
    param = {"category_id": widget.category['id']};
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
      loader = true;
      setState(() {});
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

  void onChangedCity(value) {
    if (value.isEmpty) {
      param.remove("city_id");
    } else {
      param.addAll({"city_id": value['id']});
    }
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width - 100,
          actions: [
            GestureDetector(
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorComponent.mainColor),
                child: SvgPicture.asset("assets/icons/filter.svg", width: 20),
              ),
            )
          ],
          leading: BackTitleButton(
              title: widget.category['title'],
              onPressed: () => Navigator.pop(context)),
          bottom: PreferredSize(
              preferredSize: Size(double.infinity, 44),
              child: SortAdWidget(onChangedCity: onChangedCity)),
        ),
        body: loader
            ? LoaderComponent()
            : Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          controller: scrollController,
                          itemBuilder: (context, int index) {
                            Map value = data[index];
                            if (data.length - 1 == index) {
                              return Column(children: [
                                AdItem(data: value, showCategory: false),
                                hasNextPage
                                    ? PaginationLoaderComponent()
                                    : Container()
                              ]);
                            } else {
                              return AdItem(data: value, showCategory: false);
                            }
                          }))
                ],
              ));
  }
}
