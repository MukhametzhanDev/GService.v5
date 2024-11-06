import 'package:flutter/material.dart';
import 'package:gservice5/component/button/backIconButton.dart';
import 'package:gservice5/component/select/selectButton.dart';

class RegistrationCustomerPage extends StatefulWidget {
  final Map data;
  const RegistrationCustomerPage({super.key, required this.data});

  @override
  State<RegistrationCustomerPage> createState() =>
      _RegistrationCustomerPageState();
}

class _RegistrationCustomerPageState extends State<RegistrationCustomerPage> {
  Map cityData = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackIconButton(), title: Text("Данные компании")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          SelectButton(
              title: "Выберите город",
              active: cityData.isNotEmpty,
              onPressed: () {})
        ]),
      ),
    );
  }
}
