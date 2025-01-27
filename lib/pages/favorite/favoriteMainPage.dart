import 'package:flutter/material.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/pages/auth/emptyTokenPage.dart';
import 'package:gservice5/pages/favorite/ad/listFavoriteAdPage.dart';
import 'package:gservice5/pages/favorite/ad/listFavoriteApplicationPage.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class FavoriteMainPage extends StatefulWidget {
  const FavoriteMainPage({super.key});

  @override
  State<FavoriteMainPage> createState() => _FavoriteMainPageState();
}

class _FavoriteMainPageState extends State<FavoriteMainPage> {
  bool token = false;

  @override
  void initState() {
    getToken();
    super.initState();
  }

  Future getToken() async {
    token = await ChangedToken().getToken() != null;
    print("TOKEN $token");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List _tabs = [context.localizations.ads, context.localizations.orders];
    return !token
        ? const EmptyTokenPage()
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 2,
                bottom: PreferredSize(
                    preferredSize: Size(MediaQuery.of(context).size.width, 49),
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 2, color: Color(0xfff4f5f7)))),
                      child: TabBar(
                          indicatorWeight: 3,
                          isScrollable: false,
                          // tabAlignment: TabAlignment.start,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: _tabs.map((value) {
                            return Tab(text: value);
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 10),
                            //   child: Row(children: [
                            //     Text(value),
                            //     Container(
                            //       width: 20,
                            //       height: 20,
                            //       margin: EdgeInsets.only(left: 10),
                            //       alignment: Alignment.center,
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(20),
                            //           color: ColorComponent.mainColor
                            //               .withOpacity(.1)),
                            //       child: Text(
                            //         "99",
                            //         style: TextStyle(
                            //             fontSize: 12,
                            //             fontWeight: FontWeight.w500,
                            //             color: Colors.black),
                            //       ),
                            //     )
                            //   ]),
                            // );
                          }).toList()),
                    )),
              ),
              body: const TabBarView(children: [
                ListFavoriteAdPage(),
                ListFavoriteApplicationPage(),
                // Container()
              ]),
            ),
          );
  }
}
