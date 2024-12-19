import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:gservice5/pages/create/ad/characteristic/getCharacteristicAdPage.dart';
import 'package:gservice5/pages/create/ad/characteristic/modalButtonComponent.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DataModal extends StatefulWidget {
  String title;
  String placeholderTitle;
  final data;
  final value;
  final addData;
  DataModal(
      {super.key,
      @required this.addData,
      @required this.data,
      @required this.value,
      required this.title,
      required this.placeholderTitle});

  @override
  State<DataModal> createState() => _DataModalState();
}

class _DataModalState extends State<DataModal> {
  void showModal() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => ListModalComponent(
              addData: widget.addData,
              data: widget.data,
              value: widget.value,
              placeholderTitle: widget.placeholderTitle,
            ));
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
  String placeholderTitle;
  final data;
  final addData;
  final value;
  ListModalComponent(
      {super.key,
      @required this.addData,
      @required this.data,
      @required this.value,
      required this.placeholderTitle});

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
          title: Text(widget.placeholderTitle),
          actions: const [CloseIconButton(padding: true, iconColor: null)],
        ),
        body: data.isEmpty
            ? const Text("Ничего не найдено")
            : Column(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: SearchTextField(
                      onChanged: (value) => addTitle(value), title: "Поиск"),
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
                              return ListTile(
                                onTap: () => addItem(item),
                                title: Text(capitalized(item['title'] ?? ""),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              );
                            },
                          ))
              ]));
  }
}
