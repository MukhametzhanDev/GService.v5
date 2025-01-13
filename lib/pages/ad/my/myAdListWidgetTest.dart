import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/my/business/updateAds.dart';
import 'package:gservice5/pages/ad/my/myAdEmptyPage.dart';
import 'package:gservice5/pages/ad/my/myAdItem.dart';
import 'package:gservice5/pages/ad/my/optionsMyAdModal.dart';
import 'package:gservice5/pages/ad/my/request/myAdRequest.dart';
import 'package:gservice5/pages/ad/my/viewMyAdPage.dart';
import 'package:gservice5/pages/ad/package/listPackagePage.dart';
import 'package:gservice5/pages/application/my/viewMyApplicationPage.dart';
import 'package:gservice5/provider/myAdFilterProvider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyAdListWidgetTest extends StatefulWidget {
  const MyAdListWidgetTest({super.key});

  @override
  State<MyAdListWidgetTest> createState() => _MyAdListWidgetTestState();
}

class _MyAdListWidgetTestState extends State<MyAdListWidgetTest>
    with AutomaticKeepAliveClientMixin {
  int tabIndex = 1;
  List data = [];
  bool loader = true;
  ScrollController scrollController = ScrollController();
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  // RefreshController refreshController = RefreshController();
  Map<String, dynamic> param = UpdateAds.value;

  @override
  void initState() {
    Provider.of<MyAdFilterProvider>(context, listen: false).getData();
    super.initState();
  }

  // @override
  // void initState() {
  //   getData();
  //   checkFilteredAd();
  //   super.initState();
  //   scrollController.addListener(() => loadMoreAd());
  // }

  void checkFilteredAd() {
    UpdateAds.valueStream.listen((value) {
      param = value.cast<String, dynamic>();
      print("UPDATE GET DATA $value");
    });
    // getData();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    // refreshController.dispose();
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
      Response response = await dio.get("/my-ads", queryParameters: param);
      if (mounted) {
        print(response.data);
        if (response.data['success']) {
          data = response.data['data'];
          hasNextPage = page != response.data['meta']['last_page'];
          loader = false;
          setState(() {});
        } else {
          SnackBarComponent()
              .showErrorMessage(response.data['message'], context);
        }
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
    // refreshController.refreshCompleted();
  }

  Future loadMoreAd() async {
    if (scrollController.position.extentAfter < 200 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        Map<String, dynamic> parameter = {"page": page, ...param};
        Response response =
            await dio.get("/my-ads", queryParameters: parameter);
        if (response.data['success']) {
          data.addAll(response.data['data']);
          hasNextPage = page != response.data['meta']['last_page'];
          isLoadMore = false;
          setState(() {});
        } else {
          SnackBarComponent()
              .showErrorMessage(response.data['message'], context);
        }
      } catch (e) {
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    }
  }

  void showMyApplicationPage(int id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewMyApplicationPage(id: id))).then((value) {
      if (value == "delete") updateData(id);
    });
  }

  void updateData(int id) async {
    final index = data.indexWhere((item) => item['id'] == id);
    // await getCount();
    setState(() {
      data.removeAt(index);
    });
  }

  void showOptions(Map<String, dynamic> data) async {
    if (data['status'] == "deleted") {
      if (await MyAdRequest().restoreAd(data['id'], context)) {
        updateData(data['id']);
      }
    } else if (data['status'] == "archived") {
      if (await MyAdRequest().unZipAd(data['id'], context)) {
        updateData(data['id']);
      }
    } else {
      showCupertinoModalBottomSheet(
              context: context,
              builder: (context) =>
                  OptionsMyAdModal(data: data, status: data['status']))
          .then((value) {
        if (value == "update") {
          updateData(data['id']);
        } else if (value == "edit") {
          // refreshController.requestRefresh();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<MyAdFilterProvider>(builder: (context, data, child) {
      print("LOADING ${data.loading}");
      if (data.loading) {
        return LoaderComponent();
      } else {
        return ListView.builder(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            controller: scrollController,
            itemCount: data.ads.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> item = data.ads[index];
              return MyAdItem(
                  data: item,
                  onPressed: showPage,
                  role: "business",
                  showOptions: showOptions,
                  showListPromotionPage: showListPromotionPage);
            });
      }
    });
  }
  // ListView.builder(
  //               padding: EdgeInsets.only(
  //                   bottom: MediaQuery.of(context).padding.bottom),
  //               controller: scrollController,
  //               itemCount: data.length,
  //               itemBuilder: (context, index) {
  //                 Map<String, dynamic> item = data[index];
  //                 return MyAdItem(
  //                     data: item,
  //                     onPressed: showPage,
  //                     role: "business",
  //                     showOptions: showOptions,
  //                     showListPromotionPage: showListPromotionPage);
  //               },
  //               // )
  //             );

  void showPage(int id) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => ViewMyAdPage(id: id)))
        .then((value) {
      if (value == "update") {
        updateData(id);
      }
    });
  }

  void showListPromotionPage(Map value) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListPackagePage(
                categoryId: value['category']['id'],
                adId: value['id'],
                goBack: true))).then((element) {
      value['stickers'] = element['stickers'];
      value['ad_promotions'] = element['package']['promotions'];
      setState(() {});
    });
  }

  Tab TopTabButton(Map value) {
    return Tab(
        child: Row(children: [
      Text(value['title']),
      Container(
        width: 20,
        height: 20,
        margin: const EdgeInsets.only(left: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorComponent.mainColor.withOpacity(.1)),
        child: Text(
          value['count'],
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      )
    ]));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
