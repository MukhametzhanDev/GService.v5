import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class FavoriteMainPage extends StatefulWidget {
  const FavoriteMainPage({super.key});

  @override
  State<FavoriteMainPage> createState() => _FavoriteMainPageState();
}

class _FavoriteMainPageState extends State<FavoriteMainPage> {
  List _tabs = ["Объявлении", "Заявки", "Поиски"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 49),
              child: TabBar(
                  indicatorWeight: 3,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: _tabs.map((value) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(children: [ 
                        Text(value),
                        Container(
                          width: 20,
                          height: 20,
                          margin: EdgeInsets.only(left: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: ColorComponent.mainColor.withOpacity(.1)),
                          child: Text(
                            "99",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        )
                      ]),
                    );
                  }).toList())),
        ),
      ),
    );
  }
}
