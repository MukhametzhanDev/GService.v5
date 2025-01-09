import 'package:flutter/material.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/testCharactestic/checkboxCharacteristic.dart';
import 'package:gservice5/pages/testCharactestic/inputCharacteristicWidget.dart';
import 'package:gservice5/pages/testCharactestic/multiSelectCharactersitic.dart';
import 'package:gservice5/pages/testCharactestic/radioCharacteristicWidget.dart';
import 'package:gservice5/pages/testCharactestic/selectCharactersitic.dart';

class CharacteristicWidget extends StatelessWidget {
  final List data;
  const CharacteristicWidget({super.key, required this.data});

  Widget ChildCharacteristics(Map value) {
    if (value['child_characteristics'].isEmpty) {
      return Container();
    } else {
      return CharacteristicWidget(data: value['child_characteristics']);
    }
  }

  void addIdRadio(Map value) {
    List child = value['child_characteristics'];
    Map radioMap = child
        .where((element) => element['input_type'] == "radio")
        .toList()
        .first;
    if (radioMap.isNotEmpty) {
      CreateData.characteristic["${value['id']}"] = radioMap['id'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.map((value) {
          switch (value['field_type']) {
            case "input":
              switch (value['input_type']) {
                case "radio":
                  return Column(
                    children: [
                      RadioCharacteristicWidget(value: value),
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
