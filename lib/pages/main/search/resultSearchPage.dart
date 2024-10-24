import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/transition/fadeTransition.dart';
import 'package:gservice5/pages/main/search/mainSearchPage.dart';
import 'package:gservice5/pages/main/search/searchEmptyPage.dart';

class ResultSearchPage extends StatefulWidget {
  final String title;
  const ResultSearchPage({super.key, required this.title});

  @override
  State<ResultSearchPage> createState() => _ResultSearchPageState();
}

class _ResultSearchPageState extends State<ResultSearchPage> {
  List _tabs = ["Все", "Продажи", "Аренда", "Заказы"];
  String title = "";

  @override
  void initState() {
    title = widget.title;
    super.initState();
  }

  void showMainSearchPage() {
    // showType: back, result
    Navigator.push(
            context,
            FadeTransitionClass().showFadeTransition(
                MainSearchPage(showType: "back", title: title)))
        .then((value) {
      if (value != null) addTitle(value);
    });
  }

  void addTitle(String value) {
    print(value);
    title = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          body: SafeArea(
              child: Column(children: [
            TextButton(
              onPressed: showMainSearchPage,
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 3)),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    margin: const EdgeInsets.only(left: 16),
                    child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent),
                        child: SvgPicture.asset('assets/icons/left.svg',
                            color: Colors.black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 5),
                    child:
                        SvgPicture.asset("assets/icons/search.svg", width: 18),
                  ),
                  Expanded(
                      child: Text(title,
                          style: const TextStyle(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis))
                ],
              ),
            ),
            TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: _tabs.map((value) {
                  return Tab(text: value);
                }).toList()),
            Expanded(
              child: TabBarView(
                  children: _tabs.map((value) {
                return const SearchEmptyPage();
              }).toList()),
            ),
          ])),
        ));
  }
}
