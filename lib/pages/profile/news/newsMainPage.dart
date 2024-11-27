import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/profile/news/allNewsPage.dart';
import 'package:gservice5/pages/profile/news/myNewsPage.dart';

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
              leading: BackIconButton(),
              title: Text("Новости"),
              bottom: PreferredSize(
                  preferredSize: Size(MediaQuery.of(context).size.width, 44),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.grey))),
                    child: TabBar(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        isScrollable: !true,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: ColorComponent.mainColor,
                        labelColor: Colors.black,
                        unselectedLabelColor: ColorComponent.gray['500'],
                        tabs: [
                          Tab(text: "Мои новости"),
                          Tab(text: "Все новости")
                        ]),
                  ))),
          body: TabBarView(children: [MyNewsPage(), AllNewsPage()]),
        ));
  }
}
