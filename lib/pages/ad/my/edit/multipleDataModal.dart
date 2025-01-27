import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class MultipleDataModal extends StatefulWidget {
  final Map data;
  const MultipleDataModal({super.key, required this.data});

  @override
  State<MultipleDataModal> createState() => _MultipleDataModalState();
}

class _MultipleDataModalState extends State<MultipleDataModal> {
  List enterItems = [];

  @override
  void initState() {
    super.initState();
    print(widget.data);
    enterItems = widget.data['value'];
  }

  void showModal() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => Modal(
              data: widget.data,
              values: enterItems,
              addData: (value) {
                enterItems = value;
                setState(() {});
                // EditData.characteristic.addAll(dataID);
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    final ColorTheme = ThemeColorComponent.ColorsTheme(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.data['title'],
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => showModal(),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 50,
              decoration: BoxDecoration(
                  color: ColorComponent.gray['50'],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: const Color(0xffe5e7eb))),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Выберите",
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
        const SizedBox(height: 15),
        Wrap(
            children: enterItems.map((valueWrap) {
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.only(right: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: ColorTheme['surring_dark'],
                  borderRadius: BorderRadius.circular(8)),
              child: Text(valueWrap?['title'] ?? "",
                  style: const TextStyle(fontSize: 13)));
        }).toList()),
      ],
    );
  }
}

class Modal extends StatefulWidget {
  final Map data;
  final List values;
  final void Function(List data) addData;
  const Modal(
      {super.key,
      required this.data,
      required this.addData,
      required this.values});

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  List data = [];
  List filterData = [];
  List enterItems = [];
  List enterItemId = [];

  @override
  void initState() {
    super.initState();
    data = widget.data['options'];
    filterData = widget.data['options'];
    addData();
  }

  void addData() {
    final activeIds = widget.values.map((e) => e['value']).toSet();
    for (var item in widget.data['options']) {
      if (activeIds.contains(item['id'])) {
        item['active'] = true;
        print(item);
        enterItems.add(item);
        enterItemId.add(item['id'].toString());
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
      SnackBarComponent()
          .showErrorMessage("Вы можете выбрать не более 10 элементов", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Container(),
          title: Text(widget.data['title']),
          actions: const [CloseIconButton(padding: true, iconColor: null)]),
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
                          itemCount: filterData.length,
                          itemBuilder: (context, index) {
                            var item = filterData[index];
                            return ListTile(
                              leading: Container(
                                width: 24,
                                height: 24,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: item?['active'] ?? false
                                        ? ColorComponent.blue['700']
                                        : ColorComponent.gray['200'],
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
                            );
                          },
                        ))
            ]),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
        onPressed: () {
          print(enterItems);
          widget.addData(enterItems);
          EditData.characteristic
              .addAll({widget.data['id'].toString(): enterItemId});
          Navigator.pop(context);
        },
        padding: const EdgeInsets.symmetric(horizontal: 15),
        title: context.localizations.save
      )),
    );
  }
}
