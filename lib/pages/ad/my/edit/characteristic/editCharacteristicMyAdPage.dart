import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';

class EditCharacteristicMyAdPage extends StatefulWidget {
  final Map data;
  const EditCharacteristicMyAdPage({super.key, required this.data});

  @override
  State<EditCharacteristicMyAdPage> createState() =>
      _EditCharacteristicMyAdPageState();
}

class _EditCharacteristicMyAdPageState
    extends State<EditCharacteristicMyAdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackTitleButton(title: "Редактировать данные"),
          leadingWidth: 250),
    );
  }
}
