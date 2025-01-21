import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/banner/bannersList.dart';
import 'package:gservice5/component/button/searchButton.dart';
import 'package:gservice5/component/categories/data/mainPageData.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/request/getMainPageData.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/deeplink/appLink.dart';
import 'package:gservice5/pages/ad/item/adItem.dart';
import 'package:gservice5/pages/ad/list/adListLoader.dart';
import 'package:gservice5/pages/main/applicationListMain.dart';
import 'package:gservice5/component/categories/categoriesListWidget.dart';
import 'package:gservice5/pages/main/drawer/mainDrawer.dart';
import 'package:gservice5/pages/main/search/mainSearchPage.dart';
import 'package:share_plus/share_plus.dart';

class MainPage extends StatefulWidget {
  final ScrollController scrollController;
  const MainPage({super.key, required this.scrollController});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  Map data = MainPageData.data;
  List adList = [];
  bool loader = true;
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;

  @override
  void initState() {
    getData();
    getAdList();
    widget.scrollController.addListener(() => loadMoreAd());
    AppLink().initDeepLinks(context);
    super.initState();
  }

  Future getData() async {
    if (data.isEmpty) {
      await GetMainPageData().getData(context);
      setState(() {});
    }
  }

  void showLoader() {
    if (!loader) {
      loader = true;
      setState(() {});
    }
  }

  Future getAdList() async {
    print('object');
    try {
      page = 1;
      Response response = await dio.get("/ad");
      print(response.data);
      if (response.statusCode == 200) {
        adList = response.data['data'];
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
        Response response =
            await dio.get("/ad", queryParameters: {"page": page.toString()});
        print(response.data);
        if (response.statusCode == 200) {
          adList.addAll(response.data['data']);
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

  void showMainSearchPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const MainSearchPage(showType: "back", title: "")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 0,
          shape: const RoundedRectangleBorder(
              side: BorderSide(width: 0, color: Colors.white)),
          backgroundColor: Colors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
        ),
        body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: () async {
                await GetMainPageData().getData(context);
                await getAdList();
              },
              // color: ColorComponent.mainColor,
              child: CustomScrollView(
                  controller: widget.scrollController,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      pinned: !true,
                      snap: true,
                      floating: true,
                      leadingWidth: 55,
                      leading: Row(
                        children: [
                          const Divider(indent: 15),
                          GestureDetector(
                            onTap: () {
                              scaffoldKey.currentState?.openDrawer();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: ColorComponent.mainColor),
                              child:
                                  SvgPicture.asset('assets/icons/burger.svg'),
                            ),
                          ),
                        ],
                      ),
                      title: SearchButton(
                          title: "Поиск по GService",
                          onPressed: showMainSearchPage),
                      bottom: PreferredSize(
                          preferredSize:
                              Size(MediaQuery.of(context).size.width, 40),
                          child: const CategoriesListWidget()),
                    ),
                    SliverToBoxAdapter(
                        child: Column(children: [
                      const Divider(height: 10),
                      const BannersList(),
                      const Divider(height: 20),
                      ApplicationListMain(data: data['applications']),
                      const Divider(height: 24),
                    ])),
                    const SliverToBoxAdapter(
                      child: Padding(
                          padding:
                              EdgeInsets.only(left: 15, right: 15, bottom: 15),
                          child: Text("Спецтехники по Казахстану",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1))),
                    ),
                    loader
                        ? const SliverToBoxAdapter(child: AdListLoader())
                        : SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                            Map value = adList[index];
                            if (adList.length - 1 == index) {
                              return Column(children: [
                                AdItem(data: value),
                                hasNextPage
                                    ? const PaginationLoaderComponent()
                                    : Container()
                              ]);
                            } else {
                              return AdItem(data: value);
                            }
                          }, childCount: adList.length))
                  ]),
            )),
        drawer: const MainDrawer(),
        drawerScrimColor: Colors.black.withOpacity(.25));
  }
}
