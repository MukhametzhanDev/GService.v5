import 'package:flutter/material.dart';
import 'package:gservice5/component/alert/closeCreateAdAlert.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/ad/characteristic/getImageCreateAdPage.dart';
import 'package:gservice5/pages/create/ad/stepCreateAdWidget.dart';
import 'package:gservice5/pages/create/ad/titleCreateAdPage.dart';
import 'package:gservice5/pages/create/ad/createAdContactsPage.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/options/getSelectPage.dart';
import 'package:gservice5/pages/create/priceCreateAdPage.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';
import 'package:gservice5/pages/testCharactestic/testCharactesticPage.dart';
import 'package:gservice5/pages/testCharactestic/testChildCharactesticPage.dart';
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

  int? twoStepsBack;

  @override
  void initState() {
    super.initState();
    data = [...widget.data['options']['necessary_inputs']];
    formattedPages();
    savedCategoryId();
  }

  @override
  void dispose() {
    pageController.dispose();
    pageControllerIndexedStack.dispose();
    clearData();
    super.dispose();
  }

  void clearData() {
    CreateData.data.clear();
    CreateData.characteristic.clear();
    CreateData.images.clear();
  }

  void formattedPages() {
    closeKeyboard();
    int index = pageControllerIndexedStack.getIndex();
    if (index == data.length - 1) {
      bool showTitle = widget.data['options']['has_title'];
      pages.add(TitleCreateAdPage(
          nextPage: addCharacteristicPage,
          previousPage: previousPage,
          showTitle: showTitle));
    } else if (index < data.length) {
      addPage();
    }
    setState(() {});
  }

  void addCharacteristicPage() {
    closeKeyboard();
    // pages.add(GetCharacteristicAdPage(
    //   nextPage: addChildCharacteristicPage, previousPage: previousPage));
    Map<String, dynamic> param = {
      "category_id": CreateData.data['category_id']
    };
    pages.add(TestCharactesticPage(
        nextPage: addChildCharacteristicPage,
        previousPage: previousPage,
        param: param));
  }

  void addGetPricePage() {
    List prices = widget.data['options']['prices'] ?? [];
    closeKeyboard();
    if (prices.isEmpty) {
      addGetImagePage();
    } else {
      pages.add(PriceCreateAdPage(
          nextPage: addGetImagePage, previousPage: previousPage, data: prices));
    }
  }

  void addGetImagePage() {
    closeKeyboard();
    pages.add(GetImageCreateAdPage(
        previousPage: previousPage, nextPage: addContactPage));
  }

  void addContactPage() {
    closeKeyboard();
    pages.add(CreateAdContactsPage(previousPage: previousPage));
  }

  void addChildCharacteristicPage(List data) {
    closeKeyboard();
    if (data.isEmpty) {
      addGetPricePage();
    } else {
      pages.add(TestChildCharactesticPage(
          data: data, nextPage: addGetPricePage, previousPage: previousPage));
    }
  }

  void addPage() {
    int index = pageControllerIndexedStack.getIndex();
    closeKeyboard();
    pages.add(GetSelectPage(
        value: data[index],
        nextPage: formattedPages,
        previousPage: previousPage,
        // hasNextRemovedPage: hasNextRemovedPage,
        options: data,
        pageController: pageController));
  }

  // void hasNextRemovedPage() {
  //   int index = pageControllerIndexedStack.getIndex();
  //   twoStepsBack = index ;
  //   addPage();
  //   addPage();
  //   print("TWOSTEPRS--> ${twoStepsBack}");
  // }

  void previousPage() {
    closeKeyboard();
    int index = pageControllerIndexedStack.getIndex();
    if (index == 0) {
      Navigator.pop(context);
    } else {
      removedPage();
      setState(() {});
    }
  }

  void removedPage() {
    pages.removeLast();
    pageControllerIndexedStack.previousPage();
  }

  void savedCategoryId() {
    CreateData.data['category_id'] = widget.data['id'];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          previousPage();
          return true;
        },
        child: ValueListenableBuilder<int>(
            valueListenable: pageControllerIndexedStack.pageIndexNotifier,
            builder: (context, pageIndex, child) {
              bool showTitle = data.length - 1 > pageIndex;
              return Scaffold(
                  appBar: AppBar(
                    leadingWidth: MediaQuery.of(context).size.width - 100,
                    actions: [
                      IconButton(
                          onPressed: () {
                            showCupertinoModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                    const CloseCreateAdAlert());
                          },
                          icon: Text("Закрыть  ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: ColorComponent.blue['700'])))
                    ],
                    leading: BackTitleButton(
                        title: widget.data['title'],
                        onPressed: () => previousPage()),
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
                                          "",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)))
                              : Container(),
                          Expanded(
                              child: IndexedStack(
                                  index: pageIndex, children: pages)),
                        ],
                      )));
            }));
  }
}
