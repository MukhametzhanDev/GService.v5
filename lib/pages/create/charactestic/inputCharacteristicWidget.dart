import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';

class InputCharacteristicWidget extends StatelessWidget {
  final Map value;
  const InputCharacteristicWidget({super.key, required this.value});

  void onChanged(valueChanged) {
    print(valueChanged);
    CreateData.characteristic["${value['id']}"] = valueChanged;
  }

  TextInputType sortType() {
    String type = value['input_type'];
    if (type == "number") {
      return const TextInputType.numberWithOptions(decimal: true);
    } else if (type == "password") {
      return TextInputType.visiblePassword;
    } else if (type == "email") {
      return TextInputType.emailAddress;
    } else {
      return TextInputType.text;
    }
  }

  String getInitialValue() {
    if (CreateData.characteristic[value['id']] == null) {
      return "";
    } else {
      return CreateData.characteristic[value['id']].toString();
    }
  }

  String getTitle() {
    String title = value['title'];
    if (value['is_required']) {
      title = "$title *";
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(getTitle(), style: const TextStyle(fontSize: 13)),
      const SizedBox(height: 7),
      TextFormField(
        initialValue: getInitialValue(),
        keyboardType: sortType(),
        textCapitalization: TextCapitalization.sentences,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintStyle: TextStyle(
              fontSize: 14,
              color: ColorComponent.gray['500'],
              fontWeight: FontWeight.w400),
          hintText: value['tag_attribute']?['placeholder'] ?? "Напишите",
        ),
      ),
      const SizedBox(height: 16),
    ]);
  }
}
