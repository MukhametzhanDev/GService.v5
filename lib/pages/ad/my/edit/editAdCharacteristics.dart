import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/my/edit/multipleDataModal.dart';
import 'package:gservice5/pages/create/ad/characteristic/dataModal.dart';
import 'package:gservice5/pages/create/ad/characteristic/getCharacteristicAdPage.dart';
import 'package:gservice5/pages/create/data/createData.dart';

class EditAdCharacteristics extends StatefulWidget {
  final List value;
  final Map<String, dynamic> param;
  const EditAdCharacteristics(
      {super.key, required this.param, required this.value});

  @override
  State<EditAdCharacteristics> createState() => _EditAdCharacteristicsState();
}

class _EditAdCharacteristicsState extends State<EditAdCharacteristics> {
  Map characteristicParam = {};
  List data = [];
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response =
          await dio.get("/characteristics", queryParameters: widget.param);
      if (response.data['success']) {
        data = response.data['data'];
        await formattedData(data);
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  Future formattedData(List data) async {
    for (var elementData in data) {
      for (var elementValue in widget.value) {
        if (elementData['id'] == elementValue['characteristic']['id']) {
          elementData['value'] = elementValue['values'];
        }
        for (var elementChild in elementData['child_characteristics']) {
          if (elementChild['id'] == elementValue['characteristic']['id']) {
            elementData['value'] = elementValue['values'];
          }
        }
      }
    }
    setState(() {});
  }

  void addData(value) {
    EditData.characteristic.addAll(value);
  }

  @override
  Widget build(BuildContext context) {
    return loader
        ? const LoaderComponent()
        : SingleChildScrollView(
            child: Column(
                children: data.map((value) {
              if (value['field_type'] == "input" &&
                  value['input_type'] != "checkbox") {
                List childData = value['child_characteristics'];
                return Column(
                  children: [
                    TextFieldCharacteristic(data: value, addData: addData),
                    ChildCharacteristics(data: childData, addData: addData)
                  ],
                );
              } else if (value['field_type'] == "select") {
                List childData = value['child_characteristics'];
                bool multiple = value['tag_attribute']?["multiple"] ?? false;
                if (multiple) {
                  return Column(
                    children: [
                      MultipleSelectCharacteristic(
                          data: value, addData: addData),
                      ChildCharacteristics(data: childData, addData: addData)
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      SelectCharacteristic(data: value, addData: addData),
                      ChildCharacteristics(data: childData, addData: addData)
                    ],
                  );
                }
              } else if (value['field_type'] == "input" &&
                  value['input_type'] == "checkbox") {
                List childData = value['child_characteristics'];
                return Column(
                  children: [
                    CheckBoxCharacteristic(data: value, addData: addData),
                    ChildCharacteristics(data: childData, addData: addData)
                  ],
                );
              } else {
                return Container();
              }
            }).toList()),
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
        return TextFieldCharacteristic(data: value, addData: widget.addData);
      } else if (value['field_type'] == "select") {
        return SelectCharacteristic(addData: widget.addData, data: value);
      } else if (value['field_type'] == "input" &&
          value['input_type'] == "checkbox") {
        return CheckBoxCharacteristic(data: value, addData: widget.addData);
      } else if (value['field_type'] == "select" &&
          value['tag_attribute']["multiple"]) {
        return MultipleSelectCharacteristic(
            addData: widget.addData, data: value);
      } else {
        return Container();
      }
    }).toList());
  }
}

class MultipleSelectCharacteristic extends StatelessWidget {
  final data;
  final Function addData;
  const MultipleSelectCharacteristic(
      {super.key, required this.data, required this.addData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: MultipleDataModal(data: data),
    );
  }
}

class SelectCharacteristic extends StatefulWidget {
  final data;
  final Function addData;
  const SelectCharacteristic(
      {super.key, required this.addData, required this.data});

  @override
  State<SelectCharacteristic> createState() => _SelectCharacteristicState();
}

class _SelectCharacteristicState extends State<SelectCharacteristic> {
  var data;

  @override
  void initState() {
    super.initState();
    print("widget.data['value'] ${widget.data}");
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: DataModal(
        addData: (valueData) {
          widget.addData(
              {widget.data['id'].toString(): valueData['id'].toString()});
          data = valueData;
          setState(() {});
        },
        data: widget.data['options'],
        value: data['value'],
        title: widget.data['title'],
      ),
    );
  }
}

class TextFieldCharacteristic extends StatelessWidget {
  final data;
  final Function addData;
  const TextFieldCharacteristic(
      {super.key, required this.data, required this.addData});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(data['title'],
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      const SizedBox(height: 7),
      TextFormField(
        initialValue: data?['value']?['value'].toString() ?? "",
        keyboardType: sortType(data['input_type']),
        textCapitalization: TextCapitalization.sentences,
        onChanged: (valueChanged) {
          addData({data['id'].toString(): valueChanged});
        },
        style: const TextStyle(fontSize: 14, color: Colors.black),
        decoration: InputDecoration(
          hintText: data['tag_attribute']?['placeholder'],
        ),
      ),
      const SizedBox(height: 14),
    ]);
  }
}

class CheckBoxCharacteristic extends StatefulWidget {
  final data;
  final Function addData;
  const CheckBoxCharacteristic(
      {super.key, required this.addData, required this.data});

  @override
  State<CheckBoxCharacteristic> createState() => _CheckBoxCharacteristicState();
}

class _CheckBoxCharacteristicState extends State<CheckBoxCharacteristic> {
  bool active = false;

  @override
  void initState() {
    super.initState();
    active = widget.data?['value']?['value'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final ColorTheme = ThemeColorComponent.ColorsTheme(context);
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextButton(
            onPressed: () {
              active = !active;
              setState(() {});
              widget.addData({widget.data['id'].toString(): active});
            },
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: active
                          ? ColorComponent.mainColor
                          : ColorTheme['dark_graylike']),
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
                  child: Text(capitalized(widget.data['title']),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                )
              ],
            )));
  }
}

TextInputType sortType(value) {
  if (value == "number") {
    return TextInputType.number;
  } else if (value == "password") {
    return TextInputType.visiblePassword;
  } else if (value == "email") {
    return TextInputType.emailAddress;
  } else {
    return TextInputType.text;
  }
}
