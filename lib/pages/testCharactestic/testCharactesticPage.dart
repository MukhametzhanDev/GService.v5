import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/pages/testCharactestic/checkboxCharacteristic.dart';
import 'package:gservice5/pages/testCharactestic/inputCharacteristicWidget.dart';
import 'package:gservice5/pages/testCharactestic/multiSelectCharactersitic.dart';
import 'package:gservice5/pages/testCharactestic/radioCharacteristicWidget.dart';
import 'package:gservice5/pages/testCharactestic/selectCharactersitic.dart';

class TestCharactesticPage extends StatefulWidget {
  const TestCharactesticPage({super.key});

  @override
  State<TestCharactesticPage> createState() => _TestCharactesticPageState();
}

class _TestCharactesticPageState extends State<TestCharactesticPage> {
  List data = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/characteristics?transport_type_id=1");
      print(response.data);
      if (response.data['success']) {
        data = response.data['data'];
        setState(() {});
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Characteristic")),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: CharacteristicWidget(data: data)),
      ),
    );
  }
}

class CharacteristicWidget extends StatelessWidget {
  final List data;
  const CharacteristicWidget({super.key, required this.data});

  Widget ChildCharacteristics(Map value) {
    if (value['child_characteristics'].isEmpty) {
      print('TRUE');
      return Container();
    } else {
      print('FALSE');
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
                ChildCharacteristics(value)
              ],
            );
          } else if (value['field_type'] == "input" &&
              value['input_type'] == "checkbox") {
            return Column(
              children: [
                CheckboxCharacteristic(value: value),
                ChildCharacteristics(value)
              ],
            );
          } else if (value['field_type'] == "input") {
            return Column(
              children: [
                InputCharacteristicWidget(value: value),
                ChildCharacteristics(value)
              ],
            );
          } else if (value['field_type'] == "select" &&
              value['tag_attribute']['multiple']) {
            return Column(
              children: [
                MultiSelectCharactersitic(value: value),
                ChildCharacteristics(value)
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
