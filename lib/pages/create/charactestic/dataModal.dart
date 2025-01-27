import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:gservice5/pages/create/charactestic/getChildCharacteristicPage.dart';
import 'package:gservice5/pages/create/charactestic/modalButtonComponent.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class DataModal extends StatefulWidget {
  String title;
  final data;
  final value;
  final addData;
  DataModal(
      {super.key,
      @required this.addData,
      @required this.data,
      @required this.value,
      required this.title});

  @override
  State<DataModal> createState() => _DataModalState();
}

class _DataModalState extends State<DataModal> {
  void showModal() {
    closeKeyboard();
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => ListModalComponent(
            addData: widget.addData, data: widget.data, value: widget.value));
  }

  @override
  Widget build(BuildContext context) {
    return ModalButtonComponent(
        padding: false,
        onPressed: () => showModal(),
        title: widget.title,
        subtitle: widget.value);
  }
}

class ListModalComponent extends StatefulWidget {
  final data;
  final addData;
  final value;
  const ListModalComponent(
      {super.key,
      @required this.addData,
      @required this.data,
      @required this.value});

  @override
  State<ListModalComponent> createState() => _ListModalComponentState();
}

class _ListModalComponentState extends State<ListModalComponent> {
  final controllerSearchTitle = TextEditingController();
  List data = [];
  List filterData = [];
  var enterItem;

  @override
  void initState() {
    super.initState();
    addData();
  }

  void addData() {
    print(widget.data);
    if (widget.data != null) enterItem = widget.value;
    setState(() {
      data = widget.data;
      filterData = widget.data;
    });
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
    print(filterData);
  }

  void removeTitle() {
    controllerSearchTitle.clear();
    filterData = data;
  }

  void addItem(value) {
    print(value);
    widget.addData(value);
    enterItem = value;
    setState(() {});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 100,
          leading: Container(),
          title: const Text("Выберите"),
          actions: const [CloseIconButton(iconColor: null, padding: true)],
        ),
        body: data.isEmpty
            ? const Text("Ничего не найдено")
            // EmptyPage(
            //     icon: 'assets/icons/searchNot.svg',
            //     title: LocaleKeys.nothing_found.tr(),
            //     subTitle: LocaleKeys
            //         .Unfortunately_your_search_returned_no_results.tr(),
            //     button: false)
            : Column(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: SearchTextField(title: "Поиск", onChanged: addTitle),
                ),
                Expanded(
                    child: filterData.isEmpty
                        ? const Text("Ничего не найдено")
                        : ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom),
                            itemCount: filterData.length,
                            itemBuilder: (context, index) {
                              var item = filterData[index];
                              return Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: Color(0xfff4f5f7)))),
                                child: ListTile(
                                  onTap: () => addItem(item),
                                  title: Text(capitalized(item['title'] ?? ""),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ),
                              );
                            },
                          ))
              ]));
  }
}