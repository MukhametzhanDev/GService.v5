import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/modal/modalBottomSheetWrapper.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/component/widgets/checkBox/checkBoxWidget.dart';
import 'package:gservice5/pages/create/ad/characteristic/modalButtonComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MultiSelectCharactersitic extends StatefulWidget {
  final Map value;
  const MultiSelectCharactersitic({super.key, required this.value});

  @override
  State<MultiSelectCharactersitic> createState() =>
      _MultiSelectCharactersiticState();
}

class _MultiSelectCharactersiticState extends State<MultiSelectCharactersitic> {
  List currentValues = [];
  List<int> currentIds = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {}

  String getInitialValue() {
    if (CreateData.characteristic[widget.value['id']] == null) {
      return "";
    } else {
      return CreateData.characteristic[widget.value['id']].toString();
    }
  }

  String getTitle() {
    String title = widget.value['title'];
    if (widget.value['is_required']) {
      title = "$title *";
    }
    return title;
  }

  void showModal() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => SelectModal(
            data: widget.value['options'],
            ids: currentIds,
            values: currentValues)).then(onChanged);
  }

  void onChanged(value) {
    if (value != null) {
      CreateData.characteristic["${widget.value['id']}"] = value['ids'];
      currentValues = value['values'];
      setState(() {});
    }
  }

  void onChangedValue(value) {
    currentValues.remove(value);
    currentIds.remove(value['id']);
    value['active'] = false;
    CreateData.characteristic["${widget.value['id']}"].remove(value['id']);
    setState(() {});
    print(currentValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Text(, style: const TextStyle(fontSize: 13)),
      // const SizedBox(height: 7),
      ModalButtonComponent(
          padding: false,
          onPressed: showModal,
          title: getTitle(),
          subtitle: const {}),
      Padding(
        padding:
            EdgeInsets.only(top: currentValues.isEmpty ? 0 : 12, bottom: 16),
        child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: currentValues.map((value) {
              return GestureDetector(
                onTap: () => onChangedValue(value),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: ColorComponent.gray['200'],
                      borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(value['title'],
                          style: const TextStyle(fontSize: 12)),
                      const Divider(indent: 6),
                      SvgPicture.asset("assets/icons/close.svg",
                          color: Colors.black87, width: 16)
                    ],
                  ),
                ),
              );
            }).toList()),
      ),
    ]);
  }
}

class SelectModal extends StatefulWidget {
  final List data;
  final List values;
  final List<int> ids;
  const SelectModal(
      {super.key, required this.data, required this.values, required this.ids});

  @override
  State<SelectModal> createState() => _SelectModalState();
}

class _SelectModalState extends State<SelectModal> {
  List<int> currentIds = [];
  List currentValues = [];

  @override
  void initState() {
    // checkActive();
    currentIds = widget.ids;
    currentValues = widget.values;
    print(widget.values);
    super.initState();
  }

  void onSaved() {
    Map param = {"values": currentValues, "ids": currentIds};
    print(currentIds);
    Navigator.pop(context, param);
  }

  void onChanged(value) {
    if (value['active'] ?? false) {
      value['active'] = false;
      currentIds.remove(value['id']);
      currentValues.remove(value);
    } else {
      value['active'] = true;
      currentIds.add(value['id']);
      currentValues.add(value);
    }
    setState(() {});
  }

  // void checkActive() {
  //   Set<int> valueSet = widget.ids.toSet();
  //   widget.data.map((element) {
  //     if (valueSet.contains(element["id"])) {
  //       element["active"] = true;
  //     }
  //     return element;
  //   }).toList();
  // }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrapper(builder: (context, physics) {
      return Scaffold(
        appBar: AppBar(
            actions: const [CloseIconButton(iconColor: null, padding: true)],
            automaticallyImplyLeading: false,
            title: const Text("Выберите")),
        body: ListView.builder(
          itemCount: widget.data.length,
          physics: physics,
          itemBuilder: (context, index) {
            Map value = widget.data[index];
            bool active = value['active'] ?? false;
            return GestureDetector(
              onTap: () => onChanged(value),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: ColorComponent.gray['100']!))),
                child: ListTile(
                    title: Text(value['title'],
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                    trailing: CheckBoxWidget(active: active)),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: onSaved,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                title: "Сохранить")),
      );
    });
  }
}
