import 'package:flutter/material.dart';
import 'package:gservice5/component/alert/closeCreateAdAlert.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/ad/characteristic/getCharacteristicAdPage.dart';
import 'package:gservice5/pages/create/ad/characteristic/getChildCharacteristicPage.dart';
import 'package:gservice5/pages/create/ad/characteristic/getImageCreateAdPage.dart';
import 'package:gservice5/pages/create/ad/stepCreateAdWidget.dart';
import 'package:gservice5/pages/create/ad/titleCreateAdPage.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/options/getSelectPage.dart';
import 'package:gservice5/pages/create/priceCreateAdPage.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

//selects
//description
//characteristic
//child characteristic
//price
//image

class StructureCreateAdPage extends StatefulWidget {
  final Map data;
  const StructureCreateAdPage({super.key, required this.data});

  @override
  State<StructureCreateAdPage> createState() => _StructureCreateAdPageState();
}

class _StructureCreateAdPageState extends State<StructureCreateAdPage> {
  PageController pageController = PageController();
  List<Map> data = [];
  List<Widget> pages = [];
  double startX = 0;
  double endX = 0;
  PageControllerIndexedStack pageControllerIndexedStack =
      PageControllerIndexedStack();
  Map cityData = {
    "url": "https://dev.gservice-co.kz/api/cities",
    "name": "city_id",
    "multiple": false
  };

  @override
  void initState() {
    super.initState();
    data = [...widget.data['options']['necessary_inputs'], cityData];
    formattedPages();
    savedCategoryId();
  }

  @override
  void dispose() {
    pageController.dispose();
    pageControllerIndexedStack.dispose();
    super.dispose();
  }

  void formattedPages() {
    int index = pageControllerIndexedStack.getIndex();
    if (index == data.length - 1) {
      pages.add(TitleCreateAdPage(
          nextPage: addCharacteristicPage, previousPage: previousPage));
    } else if (index < data.length) {
      addPage();
    }

    setState(() {});
  }

  void addCharacteristicPage() {
    pages.add(GetCharacteristicAdPage(
        nextPage: addChildCharacteristicPage, previousPage: previousPage));
  }

  void addGetPricePage() {
    List prices = widget.data['options']['prices'] ?? [];
    if (prices.isEmpty) {
      addGetImagePage();
    } else {
      pages.add(PriceCreateAdPage(
          nextPage: addGetImagePage, previousPage: previousPage, data: prices));
    }
  }

  void addGetImagePage() {
    pages.add(GetImageCreateAdPage(previousPage: previousPage));
  }

  void addChildCharacteristicPage(List data) {
    if (data.isEmpty) {
      addGetPricePage();
    } else {
      pages.add(GetChildCharacteristicPage(
          data: data, nextPage: addGetPricePage, previousPage: previousPage));
    }
  }

  void addPage() {
    int index = pageControllerIndexedStack.getIndex();
    pages.add(GetSelectPage(
        value: data[index],
        nextPage: formattedPages,
        previousPage: previousPage,
        options: data,
        pageController: pageController));
  }

  void previousPage() {
    int index = pageControllerIndexedStack.getIndex();
    if (index == 0) {
      Navigator.pop(context);
    } else {
      pages.removeLast();
      pageControllerIndexedStack.previousPage();
      setState(() {});
    }
  }

  void savedCategoryId() {
    CreateData.data['category_id'] = widget.data['id'];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          previousPage();
          print("User swiped back!");
          return true;
        },
        child: ValueListenableBuilder<int>(
            valueListenable: pageControllerIndexedStack.pageIndexNotifier,
            builder: (context, pageIndex, child) {
              bool showTitle = data.length - 1 > pageIndex;
              return Scaffold(
                  appBar: AppBar(
                    // leadingWidth: MediaQuery.of(context).size.width - 100,
                    actions: [
                      IconButton(
                          onPressed: () {
                            showCupertinoModalBottomSheet(
                                context: context,
                                builder: (context) => CloseCreateAdAlert());
                          },
                          icon: Text("Закрыть  ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: ColorComponent.blue['700'])))
                    ],
                    leading: BackTitleButton(
                        title: "", onPressed: () => previousPage()),
                    bottom: PreferredSize(
                        preferredSize:
                            Size(MediaQuery.of(context).size.width, 10),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: StepCreateAdWidget(
                              options: widget.data['options'],
                              activeIndex: pageIndex),
                        )),
                  ),
                  body: GestureDetector(
                      onTap: () => closeKeyboard(),
                      onHorizontalDragStart: (details) {
                        startX = details.globalPosition.dx;
                      },
                      onHorizontalDragUpdate: (details) {
                        endX = details.globalPosition.dx;
                      },
                      onHorizontalDragEnd: (details) {
                        if (endX - startX > 100) {
                          previousPage();
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          showTitle
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12, right: 15, left: 15),
                                  child: Text(
                                      data[pageIndex]['title']?['title_ru'] ??
                                          "Выберите город",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)))
                              : Container(),
                          Expanded(
                              child: IndexedStack(
                                  children: pages, index: pageIndex)),
                        ],
                      )));
            }));
  }
}