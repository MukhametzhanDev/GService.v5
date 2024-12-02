import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/banner/bannersList.dart';
import 'package:gservice5/component/button/searchButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/categories/data/categoriesData.dart';
import 'package:gservice5/pages/main/applicationListMain.dart';
import 'package:gservice5/component/categories/categoriesListWidget.dart';
import 'package:gservice5/pages/main/drawer/mainDrawer.dart';

class MainPage extends StatefulWidget {
  final ScrollController scrollController;
  const MainPage({super.key, required this.scrollController});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  void showMainSearchPage() {}

  @override
  Widget build(BuildContext context) {
    final List _categories = CategoriesData.categories;
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(controller: widget.scrollController, slivers: [
          SliverAppBar(
            pinned: !true,
            snap: true,
            floating: true,
            leadingWidth: 55,
            leading: Row(
              children: [
                Divider(indent: 15),
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
                child: CategoriesListWidget()),
          ),
          SliverToBoxAdapter(
              child: Column(children: [
            Divider(height: 10),
            BannersList(),
            Divider(height: 28),
            ApplicationListMain(),
            Divider(height: 28),
            // AdListMain()
          ]))
        ]),
      ),
      drawer: MainDrawer(),
      drawerScrimColor: Colors.black.withOpacity(.25),
    );
  }
}
