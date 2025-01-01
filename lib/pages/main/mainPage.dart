import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/banner/bannersList.dart';
import 'package:gservice5/component/button/searchButton.dart';
import 'package:gservice5/component/categories/data/mainPageData.dart';
import 'package:gservice5/component/request/getMainPageData.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/main/adListMain.dart';
import 'package:gservice5/pages/main/applicationListMain.dart';
import 'package:gservice5/component/categories/categoriesListWidget.dart';
import 'package:gservice5/pages/main/drawer/mainDrawer.dart';
import 'package:gservice5/pages/main/search/mainSearchPage.dart';

class MainPage extends StatefulWidget {
  final ScrollController scrollController;
  const MainPage({super.key, required this.scrollController});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  Map data = MainPageData.data;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    if (data.isEmpty) {
      await GetMainPageData().getData(context);
      setState(() {});
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
          child:
              CustomScrollView(controller: widget.scrollController, slivers: [
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
                      child: SvgPicture.asset('assets/icons/burger.svg'),
                    ),
                  ),
                ],
              ),
              title: SearchButton(
                  title: "Поиск по GService", onPressed: showMainSearchPage),
              bottom: PreferredSize(
                  preferredSize: Size(MediaQuery.of(context).size.width, 40),
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
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Text("Спецтехники по Казахстану",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1))),
            ),
            AdListMain(
                scrollController: widget.scrollController, param: const {})
          ]),
        ),
        drawer: const MainDrawer(),
        drawerScrimColor: Colors.black.withOpacity(.25));
  }
}
