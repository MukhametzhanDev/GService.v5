import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/data/cache/cacheSearchTitleData.dart';
import 'package:gservice5/pages/main/search/historySearchWidget.dart';
import 'package:gservice5/pages/main/search/recommendationSearchTitleWidget.dart';
import 'package:gservice5/pages/main/search/resultSearchPage.dart';

class MainSearchPage extends StatefulWidget {
  final String showType;
  final String title;
  const MainSearchPage(
      {super.key, required this.showType, required this.title});

  @override
  State<MainSearchPage> createState() => _MainSearchPageState();
}

class _MainSearchPageState extends State<MainSearchPage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    if (widget.title.isNotEmpty) textEditingController.text = widget.title;
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void getResult(String value) {
    CacheSearchTitleData.incrementHistoryData(value);
  }

  void addTitleHistory(value) {
    textEditingController.text = value;
    setState(() {});
    getResult(value);
    showPage();
  }

  void showPage() {
    if (widget.showType == "result") {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return ResultSearchPage(title: textEditingController.text);
        },
      ));
    } else {
      Navigator.pop(context, textEditingController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Container(
                  height: 55,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        margin: EdgeInsets.only(left: 16),
                        child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent),
                            child: SvgPicture.asset('assets/icons/left.svg',
                                color: Colors.black)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 5),
                        child: SvgPicture.asset("assets/icons/search.svg",
                            width: 18),
                      ),
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 16),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          controller: textEditingController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          onSubmitted: getResult,
                          autofocus: true,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent),
                              ),
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.transparent)),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.transparent)),
                              fillColor: Colors.white,
                              hintText: "Введите ваш запрос"),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                  child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        children: [
                          HistorySearchWidget(
                              titleController: textEditingController,
                              getResult: addTitleHistory),
                          RecommendationSearchTitleWidget(
                              titleController: textEditingController,
                              getResult: addTitleHistory)
                        ],
                      )))
            ],
          )),
    );
  }
}
