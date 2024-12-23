import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

  // @override
  // void dispose() {
  //   textEditingController.dispose();
  //   super.dispose();
  // }

  void getResult(String value) {
    CacheSearchTitleData.incrementHistoryData(value);
    showPage();
  }

  void addTitleHistory(value) {
    textEditingController.text = value;
    setState(() {});
    getResult(value);
  }

  void showPage() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ResultSearchPage(title: textEditingController.text);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(
                  height: 55,
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
                        child: SvgPicture.asset(
                            "assets/icons/searchOutline.svg",
                            width: 18),
                      ),
                      Expanded(
                        child: TextField(
                          style: const TextStyle(fontSize: 16),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          controller: textEditingController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          onSubmitted: getResult,
                          autofocus: true,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent),
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.transparent)),
                              focusedErrorBorder: OutlineInputBorder(
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
