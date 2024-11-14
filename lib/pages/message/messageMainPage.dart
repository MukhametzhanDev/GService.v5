import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class MessageMainPage extends StatefulWidget {
  const MessageMainPage({super.key});

  @override
  State<MessageMainPage> createState() => _MessageMainPageState();
}

class _MessageMainPageState extends State<MessageMainPage> {
  List _tabs = ["Все", "Новые"];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight: 4,
            bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 44),
                child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorWeight: 2,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Colors.black,
                    unselectedLabelColor: ColorComponent.gray['500'],
                    tabs: _tabs.map((value) {
                      return Tab(
                        child: Row(
                          children: [
                            Text(value),
                            Container(
                              width: 20,
                              height: 20,
                              margin: EdgeInsets.only(left: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      ColorComponent.mainColor.withOpacity(.1)),
                              child: Text(
                                "99",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList()))),
        body: TabBarView(
            children: _tabs.map((value) {
          return ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Color(0xffeeeeee)))),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  leading: CacheImage(
                      url:
                          "https://dev.agrokz.com/storage/ad-images/53/lEi2N7yGIRtyP3nl1m9sBrOKerl31UHFAfk7Yr92.jpg",
                      width: 48,
                      height: 48,
                      borderRadius: 24),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("agrokz.com",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(width: 8),
                          SvgPicture.asset('assets/icons/badgeCheck.svg')
                        ],
                      ),
                      SizedBox(height: 6),
                      Text("Добро пожаловать!",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: ColorComponent.gray['500']),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "сегодня",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: ColorComponent.gray['500']),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.only(left: 10, bottom: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: ColorComponent.red['500']),
                        child: Text(
                          "99",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }).toList()),
      ),
    );
  }
}
