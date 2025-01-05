import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/ad/characteristic/dataModal.dart';
import 'package:gservice5/pages/create/ad/characteristic/multipleDataModal.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';

class GetChildCharacteristicPage extends StatefulWidget {
  final List data;
  final void Function() nextPage;
  final void Function() previousPage;
  const GetChildCharacteristicPage(
      {super.key,
      required this.data,
      required this.nextPage,
      required this.previousPage});

  @override
  State<GetChildCharacteristicPage> createState() =>
      _GetChildCharacteristicPageState();
}

class _GetChildCharacteristicPageState
    extends State<GetChildCharacteristicPage> {
  Map characteristicParam = {};
  List data = [];
  PageControllerIndexedStack pageControllerIndexedStack =
      PageControllerIndexedStack();

  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  void verifyData() {
    for (Map value in data) {
      bool hasKey =
          CreateData.characteristic.containsKey(value['id'].toString());
      if (value['is_required'] && !hasKey) {
        SnackBarComponent()
            .showErrorMessage("Заполните строку '${value['title']}'", context);
        return;
      }
    }
    showPage();
  }

  void showPage() {
    widget.nextPage();
    pageControllerIndexedStack.nextPage();
  }

  void addData(id, value) {
    CreateData.characteristic.addAll(id);
    setState(() {});
    print(id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text("Доп. характеристики",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600))),
                Column(
                    children: data.map((value) {
                  if (value['field_type'] == "input" &&
                      value['input_type'] != "checkbox") {
                    List childData = value['child_characteristics'];
                    return Column(
                      children: [
                        TextFieldCharacteristic(value: value, addData: addData),
                        ChildCharacteristics(data: childData, addData: addData)
                      ],
                    );
                  } else if (value['field_type'] == "select") {
                    List childData = value['child_characteristics'];
                    bool multiple =
                        value['tag_attribute']?["multiple"] ?? false;
                    if (multiple) {
                      return Column(
                        children: [
                          MultipleSelectCharacteristic(
                              value: value, addData: addData),
                          ChildCharacteristics(
                              data: childData, addData: addData)
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          SelectCharacteristic(value: value, addData: addData),
                          ChildCharacteristics(
                              data: childData, addData: addData)
                        ],
                      );
                    }
                  } else if (value['field_type'] == "input" &&
                      value['input_type'] == "checkbox") {
                    List childData = value['child_characteristics'];
                    return Column(
                      children: [
                        CheckBoxCharacteristic(value: value, addData: addData),
                        ChildCharacteristics(data: childData, addData: addData)
                      ],
                    );
                  } else {
                    return Container();
                  }
                }).toList()),
              ],
            )),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: verifyData,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                title: "Сохранить")),
      ),
    );
  }
}

class ChildCharacteristics extends StatefulWidget {
  final List data;
  final Function addData;
  const ChildCharacteristics(
      {super.key, required this.data, required this.addData});

  @override
  State<ChildCharacteristics> createState() => _ChildCharacteristicsState();
}

class _ChildCharacteristicsState extends State<ChildCharacteristics> {
  Map characteristic = {};
  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.data.map((value) {
      if (value['field_type'] == "input" && value['input_type'] != "checkbox") {
        return TextFieldCharacteristic(value: value, addData: widget.addData);
      } else if (value['field_type'] == "select") {
        return SelectCharacteristic(value: value, addData: widget.addData);
      } else if (value['field_type'] == "input" &&
          value['input_type'] == "checkbox") {
        return CheckBoxCharacteristic(value: value, addData: widget.addData);
      } else if (value['field_type'] == "select" &&
          value['tag_attribute']["multiple"]) {
        return MultipleSelectCharacteristic(
            value: value, addData: widget.addData);
      } else {
        return Container();
      }
    }).toList());
  }
}

class MultipleSelectCharacteristic extends StatelessWidget {
  final value;
  final Function addData;
  const MultipleSelectCharacteristic(
      {super.key, required this.value, required this.addData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: MultipleDataModal(
          addData: (selectIds, selectData) {
            addData({value['id'].toString(): selectIds},
                {value['title'].toString(): selectData});
          },
          data: value['options'],
          title: value['title'],
          placeholderTitle: "Выберите",
          values: const []),
    );
  }
}

class SelectCharacteristic extends StatefulWidget {
  final value;
  final Function addData;
  const SelectCharacteristic(
      {super.key, required this.value, required this.addData});

  @override
  State<SelectCharacteristic> createState() => _SelectCharacteristicState();
}

class _SelectCharacteristicState extends State<SelectCharacteristic> {
  Map? data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: DataModal(
        addData: (value) {
          widget.addData(
              {widget.value['id'].toString(): value['id'].toString()},
              {widget.value['title']: value['title']});
          data = value;
          setState(() {});
          closeKeyboard();
        },
        data: widget.value['options'],
        value: data,
        title: widget.value['title'],
      ),
    );
  }
}

class TextFieldCharacteristic extends StatelessWidget {
  final value;
  final Function addData;
  const TextFieldCharacteristic(
      {super.key, required this.value, required this.addData});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value['title'], style: const TextStyle(fontSize: 14)),
      const SizedBox(height: 7),
      TextField(
        keyboardType: sortType(value['input_type']),
        textCapitalization: TextCapitalization.sentences,
        onChanged: (valueChanged) {
          addData({value['id'].toString(): valueChanged},
              {value['title']: valueChanged});
        },
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintStyle: TextStyle(
              fontSize: 14,
              color: ColorComponent.gray['500'],
              fontWeight: FontWeight.w400),
          hintText: "Напишите",
          labelText: value['tag_attribute']?['placeholder'],
        ),
      ),
      const SizedBox(height: 14),
    ]);
  }
}

class CheckBoxCharacteristic extends StatefulWidget {
  final value;
  final Function addData;
  const CheckBoxCharacteristic(
      {super.key, required this.value, required this.addData});

  @override
  State<CheckBoxCharacteristic> createState() => _CheckBoxCharacteristicState();
}

class _CheckBoxCharacteristicState extends State<CheckBoxCharacteristic> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextButton(
            onPressed: () {
              active = !active;
              setState(() {});
              widget.addData({widget.value['id'].toString(): active},
                  {widget.value['title']: active});
            },
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: active
                          ? ColorComponent.blue['500']
                          : ColorComponent.gray['200']),
                  child: active
                      ? Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14)),
                        )
                      : Container(),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 80,
                  child: Text(capitalized(widget.value['title']),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400)),
                )
              ],
            )));
  }
}

TextInputType sortType(value) {
  if (value == "number") {
    return const TextInputType.numberWithOptions(decimal: true);
  } else if (value == "password") {
    return TextInputType.visiblePassword;
  } else if (value == "email") {
    return TextInputType.emailAddress;
  } else {
    return TextInputType.text;
  }
}

String capitalized(String value) {
  if (value.isEmpty) {
    return "";
  } else {
    String capitalizedString = value[0].toUpperCase() + value.substring(1);

    return capitalizedString;
  }
}
