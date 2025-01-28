import 'package:flutter/material.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/charactestic/checkboxCharacteristic.dart';
import 'package:gservice5/pages/create/charactestic/inputCharacteristicWidget.dart';
import 'package:gservice5/pages/create/charactestic/multiSelectCharactersitic.dart';
import 'package:gservice5/pages/create/charactestic/radioCharacteristicWidget.dart';
import 'package:gservice5/pages/create/charactestic/selectCharactersitic.dart';

class CharacteristicWidget extends StatefulWidget {
  final List data;
  final int? parentId;
  const CharacteristicWidget({super.key, required this.data, this.parentId});

  @override
  State<CharacteristicWidget> createState() => _CharacteristicWidgetState();
}

class _CharacteristicWidgetState extends State<CharacteristicWidget> {
  Widget ChildCharacteristics(Map value) {
    if (value['child_characteristics'].isEmpty) {
      return Container();
    } else {
      return CharacteristicWidget(
          data: value['child_characteristics'], parentId: value['id']);
    }
  }

  void onChangedRadio(int id) {
    closeKeyboard();
    CreateData.characteristic["${widget.parentId}"] = id;
    setState(() {});
  }

  bool verifyActiveRadio(value) {
    bool active =
        CreateData.characteristic["${widget.parentId}"] == value['id'];
    return active;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.data.map((value) {
          switch (value['field_type']) {
            case "input":
              switch (value['input_type']) {
                case "radio":
                  return Column(
                    children: [
                      RadioCharacteristicWidget(
                          value: value,
                          active: verifyActiveRadio(value),
                          onChanged: onChangedRadio),
                      ChildCharacteristics(value)
                    ],
                  );
                case "checkbox":
                  return Column(
                    children: [
                      CheckboxCharacteristic(value: value),
                      ChildCharacteristics(value)
                    ],
                  );
                default:
                  return Column(
                    children: [
                      InputCharacteristicWidget(value: value),
                      ChildCharacteristics(value)
                    ],
                  );
              }
            case "select":
              if (value['tag_attribute']['multiple'] == true) {
                return Column(
                  children: [
                    MultiSelectCharactersitic(value: value),
                    ChildCharacteristics(value)
                  ],
                );
              } else {
                return SelectCharactersitic(value: value);
              }
            case "label":
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value['title'], style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 7),
                  ChildCharacteristics(value)
                ],
              );
            default:
              return const SizedBox.shrink();
          }
        }).toList());
  }
}
