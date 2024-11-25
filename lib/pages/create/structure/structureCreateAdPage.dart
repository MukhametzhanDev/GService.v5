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
import 'package:gservice5/pages/create/data/optionTitlesData.dart';
import 'package:gservice5/pages/create/options/getSelectPage.dart';
import 'package:gservice5/pages/create/priceCreateAdPage.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class StructureCreateAdPage extends StatefulWidget {
  final Map data;
  const StructureCreateAdPage({super.key, required this.data});

  @override
  State<StructureCreateAdPage> createState() => _StructureCreateAdPageState();
}

class _StructureCreateAdPageState extends State<StructureCreateAdPage> {
  PageController pageController = PageController();
  List<Widget> pages = [];
  bool loader = true;
  double startX = 0;
  double endX = 0;
  List titles = [];

  PageControllerIndexedStack pageControllerIndexedStack =
      PageControllerIndexedStack();

  @override
  void initState() {
    super.initState();
    widget.data['options']['necessary_inputs'].add({
      "url": "https://dev.gservice-co.kz/api/cities",
      "name": "city_id",
      "multiple": false
    });
    formattedPages();
    savedCategoryId();
  }

  void formattedPages() {
    List options = widget.data['options']['necessary_inputs'];
    int index = pageControllerIndexedStack.getIndex();
    if (index == options.length - 1) {
      titles.add("Описание");
      pages.add(TitleCreateAdPage(
          nextPage: addCharacteristicPage, previousPage: previousPage));
    } else if (index < options.length) {
      addPage();
    }

    setState(() {});
  }

  void addCharacteristicPage() {
    titles.add("Характеристики");
    pages.add(GetCharacteristicAdPage(
        nextPage: addChildCharacteristicPage, previousPage: previousPage));
  }

  void addGetPricePage() {
    titles.add("Цена");
    Map prices = widget.data['options']['prices'];
    pages.add(PriceCreateAdPage(
        nextPage: addGetImagePage, previousPage: previousPage, data: prices));
  }

  void addGetImagePage() {
    titles.add("Загрузка изоброжений");
    pages.add(GetImageCreateAdPage(previousPage: previousPage));
  }

  void addChildCharacteristicPage(List data) {
    if (data.isEmpty) {
      addGetPricePage();
    } else {
      titles.add("Дополнительные характеристики");
      pages.add(GetChildCharacteristicPage(
          data: data, nextPage: addGetPricePage, previousPage: previousPage));
    }
  }

  void addPage() {
    List options = widget.data['options']['necessary_inputs'];
    int index = pageControllerIndexedStack.getIndex();
    String title = OptionTitlesData.titles[options[index]['name']];
    titles.add(title);
    pages.add(GetSelectPage(
        value: options[index],
        nextPage: formattedPages,
        previousPage: previousPage,
        options: widget.data['options']['necessary_inputs'],
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
              return Scaffold(
                  appBar: AppBar(
                    leadingWidth: MediaQuery.of(context).size.width - 100,
                    actions: [
                      IconButton(
                          onPressed: () {
                            showCupertinoModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                  CloseCreateAdAlert());
                          },
                          icon: Text(
                            "Закрыть  ",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: ColorComponent.blue['700']),
                          ))
                    ],
                    leading: BackTitleButton(
                        title: titles[pageIndex]! ?? "",
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
                      child: IndexedStack(children: pages, index: pageIndex)));
            }));
  }
}
