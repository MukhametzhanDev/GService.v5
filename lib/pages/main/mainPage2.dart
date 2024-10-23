import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/banner/bannersList.dart';
import 'package:gservice5/component/button/searchButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/data/categoriesData.dart';
import 'package:gservice5/pages/main/adListMain.dart';
import 'package:gservice5/pages/main/applicationListMain.dart';
import 'package:gservice5/pages/main/drawer/mainDrawer.dart';

class MainPage2 extends StatefulWidget {
  const MainPage2({super.key});

  @override
  State<MainPage2> createState() => _MainPage2State();
}

class _MainPage2State extends State<MainPage2> {
  @override
  Widget build(BuildContext context) {
    final List _categories = CategoriesData.categories;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ExtendedNestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
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
                          Scaffold.of(context).openDrawer();
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
                  title: SearchButton(),
                  bottom: PreferredSize(
                      preferredSize:
                          Size(MediaQuery.of(context).size.width, 40),
                      child: SizedBox(
                          height: 40,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _categories.map((value) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                        height: 32,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: ColorComponent.mainColor
                                                .withOpacity(.2)),
                                        child: Text(value['title'],
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                height: 1))),
                                  );
                                }).toList()),
                          ))),
                ),
              ];
            },
            body: SingleChildScrollView(
              child: Column(children: [
                Divider(height: 10),
                BannersList(),
                Divider(height: 16),
                ApplicationListMain(),
                Divider(height: 24),
                AdListMain()
              ]),
            )),
      ),
      drawer: MainDrawer(),
      drawerScrimColor: Colors.black.withOpacity(.25),
    );
  }
}
