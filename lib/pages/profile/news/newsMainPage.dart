import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/profile/news/allNewsPage.dart';
import 'package:gservice5/pages/profile/news/myNewsPage.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class NewsMainPage extends StatefulWidget {
  const NewsMainPage({super.key});

  @override
  State<NewsMainPage> createState() => _NewsMainPageState();
}

class _NewsMainPageState extends State<NewsMainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              leading: BackTitleButton(title: context.localizations.news),
              leadingWidth: 150,
              bottom: PreferredSize(
                  preferredSize: Size(MediaQuery.of(context).size.width, 44),
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 2, color: Color(0xfff4f5f7)))),
                    child: TabBar(
                        isScrollable: !true,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: ColorComponent.mainColor,
                        labelColor: Colors.black,
                        unselectedLabelColor: ColorComponent.gray['500'],
                        tabs: const [
                          Tab(text: "Все новости"),
                          Tab(text: "Мои новости")
                        ]),
                  ))),
          body: const TabBarView(children: [AllNewsPage(), MyNewsPage()]),
        ));
  }
}
