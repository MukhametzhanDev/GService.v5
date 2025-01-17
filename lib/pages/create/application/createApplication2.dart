import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/alert/closeCreateAdAlert.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/ad/characteristic/getChildCharacteristicPage.dart';
import 'package:gservice5/pages/create/application/createApplicationContactsPage.dart';
import 'package:gservice5/pages/create/application/descriptionCreateApplicationPage.dart';
import 'package:gservice5/pages/create/application/getImageCreateApplicaitonPage.dart';
import 'package:gservice5/pages/create/application/priceCreateApplicationPage.dart';
import 'package:gservice5/pages/create/application/stepCreateApplicationWidget.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/options/getSelectPage.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

//selects
//description
//characteristic
//child characteristic
//price
//image

class CreateApplication2 extends StatefulWidget {
  final Map data;
  const CreateApplication2({super.key, required this.data});

  @override
  State<CreateApplication2> createState() => _CreateApplication2State();
}

class _CreateApplication2State extends State<CreateApplication2> {
  PageController pageController = PageController();
  List<Map> data = [];
  List<Widget> pages = [];
  double startX = 0;
  double endX = 0;
  PageControllerIndexedStack pageControllerIndexedStack =
      PageControllerIndexedStack();

  int? twoStepsBack;

  final analytics = FirebaseAnalytics.instance;

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
    if (index == data.length) {
      addDescriptionPage();
    } else if (index < data.length) {
      addPage();
    }
    setState(() {});
  }

  void addDescriptionPage() {
    closeKeyboard();
    pages.add(DescriptionCreateApplicationPage(
        exampleTitle: widget.data['options']['description_placeholder']
            ['title_ru'],
        previousPage: previousPage,
        nextPage: addGetPricePage));
  }

  void addGetPricePage() {
    closeKeyboard();
    bool canLease = widget.data['can_lease'];
    pages.add(PriceCreateApplicationPage(
        nextPage: addGetImagePage, canLease: canLease));
  }

  void addGetImagePage() {
    closeKeyboard();
    pages.add(GetImageCreateApplicaitonPage(nextPage: addContactPage));
  }

  void addContactPage() {
    closeKeyboard();
    pages.add(const CreateApplicationContactsPage());
  }

  void addChildCharacteristicPage(List data) {
    closeKeyboard();
    if (data.isEmpty) {
      addGetPricePage();
    } else {
      pages.add(GetChildCharacteristicPage(
          data: data, nextPage: addGetPricePage, previousPage: previousPage));
    }
  }

  void addPage() {
    int index = pageControllerIndexedStack.getIndex();
    closeKeyboard();
    pages.add(GetSelectPage(
        listIndex: index.toString(),
        gaListId: GAParams.listApplicationSelectId,
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
              bool showTitle = data.length > pageIndex;
              return Scaffold(
                  appBar: AppBar(
                    // leadingWidth: MediaQuery.of(context).size.width - 100,
                    actions: [
                      IconButton(
                          onPressed: () {
                            showCupertinoModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                    const CloseCreateAdAlert());

                            analytics.logEvent(
                                name: GAEventName.buttonClick,
                                parameters: {
                                  GAKey.buttonName:
                                      GAParams.txtbtnCloseApplication
                                }).catchError((e) {
                              if (kDebugMode) {
                                debugPrint(e);
                              }
                            });
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
                          child: StepCreateApplicationWidget(
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
                                      data[pageIndex]['title']?['title_ru'],
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
