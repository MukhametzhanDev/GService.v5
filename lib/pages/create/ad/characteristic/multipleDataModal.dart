import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MultipleDataModal extends StatefulWidget {
  String title;
  String placeholderTitle;
  List data;
  List values;
  final addData;
  MultipleDataModal(
      {super.key,
      @required this.addData,
      required this.title,
      required this.values,
      required this.data,
      required this.placeholderTitle});

  @override
  State<MultipleDataModal> createState() => _MultipleDataModalState();
}

class _MultipleDataModalState extends State<MultipleDataModal> {
  List enterItems = [];

  @override
  void initState() {
    super.initState();
    addButtonTitles(widget.values);
  }

  void addButtonTitles(List value) {
    enterItems = value;
    setState(() {});
  }

  void showModal() {
    closeKeyboard();
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => Modal(
              addData: widget.addData,
              title: widget.title,
              values: widget.values,
              addButtonTitle: addButtonTitles,
              data: widget.data,
              placeholderTitle: widget.placeholderTitle,
            )).then((value) {
      if (value != null) {
        enterItems = value;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => showModal(),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 50,
              decoration: BoxDecoration(
                  color: ColorComponent.gray['50'],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Color(0xffe5e7eb))),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.placeholderTitle,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: widget.data.isNotEmpty
                              ? ColorComponent.gray['500']
                              : Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SvgPicture.asset('assets/icons/down.svg',
                      color: ColorComponent.gray['400'])
                ],
              )),
        ),

        // ListView.builder(
        //   itemCount: enterItems.length,
        //   scrollDirection: Axis.horizontal,
        //   itemBuilder: (context, index) {
        //     var item = enterItems[index];
        //     return Padding(
        //       padding: const EdgeInsets.only(top: 14),
        //       child: Text(
        //         item['title'] +
        //             (enterItems.length - 1 == index ? "" : ", "),
        //         style: TextStyle(
        //             fontSize: 18,
        //             fontWeight: FontWeight.w400,
        //             color: widget.data.isEmpty
        //                 ? ColorTheme['darkPlace_grayLike']
        //                 : ColorTheme['black_white']),
        //         maxLines: 1,
        //         overflow: TextOverflow.ellipsis,
        //       ),
        //     );
        //   },
        // )
        SizedBox(height: 15),
        Wrap(
            children: enterItems.map((valueWrap) {
          // bool show = valueWrap?['active'] ?? false;
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: EdgeInsets.only(right: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: ColorComponent.gray['200'],
                  borderRadius: BorderRadius.circular(8)),
              child: Text(valueWrap?['title'] ?? "",
                  style: TextStyle(fontSize: 12)));
        }).toList()),
      ],
    );
  }
}

class Modal extends StatefulWidget {
  String title;
  List values;
  String placeholderTitle;
  List data;
  final addData;
  final addButtonTitle;
  Modal(
      {super.key,
      @required this.addData,
      @required this.addButtonTitle,
      required this.title,
      required this.values,
      required this.data,
      required this.placeholderTitle});

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  final controllerSearchTitle = TextEditingController();
  List data = [];
  List filterData = [];
  List enterItems = [];
  List enterItemId = [];

  @override
  void initState() {
    super.initState();
    data = widget.data;
    filterData = widget.data;
    addData();
  }

  @override
  void dispose() {
    super.dispose();
    controllerSearchTitle.dispose();
  }

  void addData() {
    print(widget.values);
    for (var element in widget.data) {
      if (element?['active'] ?? false) {
        element['active'] = true;
        enterItems.add(element);
        enterItemId.add(element['id'].toString());
      }
    }
    setState(() {});
  }

  void addTitle(String value) {
    if (value.isNotEmpty) {
      filterData = data
          .where((element) =>
              element['title'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      filterData = data;
    }
    setState(() {});
  }

  void removeTitle() {
    controllerSearchTitle.clear();
    filterData = data;
  }

  void addItem(value) {
    if (enterItems.isNotEmpty) {
      if (value?['active'] ?? false) {
        enterItems.remove(value);
        enterItemId.remove(value['id']);
        value['active'] = false;
      } else {
        verifyAddItem(value);
      }
    } else {
      verifyAddItem(value);
    }
    setState(() {});
    print(enterItems);
  }

  void verifyAddItem(value) {
    if (enterItems.length <= 10) {
      enterItems.add(value);
      enterItemId.add(value['id']);
      value['active'] = true;
    } else {
      SnackBarComponent().showErrorMessage("Макс 10 айтем", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorTheme = ThemeColorComponent.ColorsTheme(context);
    return Scaffold(
      appBar: AppBar(
          leading: Container(),
          title: Text(widget.placeholderTitle),
          actions: [CloseButton()]),
      body: data.isEmpty
          ? Text("Ничего не найдено")
          // EmptyPage(
          //     icon: 'assets/icons/searchNot.svg',
          //     title: LocaleKeys.nothing_found.tr(),
          //     subTitle:
          //         LocaleKeys.Unfortunately_your_search_returned_no_results.tr(),
          //     button: false)
          : Column(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: SearchTextField(title: "Поиск", onChanged: addTitle),
              ),
              Expanded(
                  child: filterData.isEmpty
                      ? Text("Ничего не найдено")
                      // EmptyPage(
                      //     icon: 'assets/icons/searchNot.svg',
                      //     title: LocaleKeys.nothing_found.tr(),
                      //     subTitle: LocaleKeys
                      //             .Unfortunately_your_search_returned_no_results
                      //         .tr(),
                      //     button: false)
                      : ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          itemCount: filterData.length,
                          itemBuilder: (context, index) {
                            var item = filterData[index];
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: Color(0xfff4f5f7)))),
                              child: ListTile(
                                leading: Container(
                                  width: 24,
                                  height: 24,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: item?['active'] ?? false
                                          ? ColorComponent.blue['700']
                                          : ColorTheme['dark_graylike'],
                                      borderRadius: BorderRadius.circular(4)),
                                  child: item?['active'] ?? false
                                      ? SvgPicture.asset(
                                          'assets/icons/checkMini.svg')
                                      : Container(),
                                ),
                                minLeadingWidth: 28,
                                onTap: () => addItem(item),
                                title: Text(item['title'] ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400)),
                              ),
                            );
                          },
                        ))
            ]),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: () {
                widget.addData(enterItemId, enterItems);
                Navigator.pop(context, enterItems);
              },
              padding: EdgeInsets.symmetric(horizontal: 15),
              title: "Продолжить")),
    );
  }
}
