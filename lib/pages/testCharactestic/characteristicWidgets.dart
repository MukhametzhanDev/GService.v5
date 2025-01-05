import 'package:flutter/material.dart';
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
      return CharacteristicWidget(data: (value['child_characteristics']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.map((value) {
          if (value['field_type'] == "input" &&
              value['input_type'] == "radio") {
            return Column(
              children: [
                RadioCharacteristicWidget(value: value),
                ChildCharacteristics(value),
              ],
            );
          } else if (value['field_type'] == "input" &&
              value['input_type'] == "checkbox") {
            return Column(
              children: [
                CheckboxCharacteristic(value: value),
                ChildCharacteristics(value),
              ],
            );
          } else if (value['field_type'] == "input") {
            return Column(
              children: [
                InputCharacteristicWidget(value: value),
                ChildCharacteristics(value),
              ],
            );
          } else if (value['field_type'] == "select" &&
              value['tag_attribute']['multiple']) {
            return Column(
              children: [
                MultiSelectCharactersitic(value: value),
                ChildCharacteristics(value),
              ],
            );
          } else if (value['field_type'] == "select" &&
              value['tag_attribute']['multiple'] == false) {
            return SelectCharactersitic(value: value);
          } else {
            return Text(value['title']);
          }
        }).toList());
  }
}
