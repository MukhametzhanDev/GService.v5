import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/message/explanatoryMessage.dart';
import 'package:gservice5/component/select/select.dart';
import 'package:gservice5/component/select/selectButton.dart';
import 'package:gservice5/component/textField/priceTextField.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';

class AddressCreateApplicationPage extends StatefulWidget {
  final void Function() nextPage;
  const AddressCreateApplicationPage({super.key, required this.nextPage});

  @override
  State<AddressCreateApplicationPage> createState() =>
      _AddressCreateApplicationPageState();
}

class _AddressCreateApplicationPageState
    extends State<AddressCreateApplicationPage> {
  Map country = {};
  Map city = {};
  Map address = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          Select(
              title: "Страна",
              onChanged: (value) {
                country = value;
                setState(() {});
              },
              pagination: false,
              api: "/countries"),
          Divider(),
          Select(
              title: "Город",
              onChanged: (value) {
                city = value;
                setState(() {});
              },
              pagination: false,
              api: "/cities?country_id=${country['id']}"),
          Divider(),
          SelectButton(title: "Введите адрес", active: false, onPressed: () {})
        ]),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: () {},
              padding: EdgeInsets.symmetric(horizontal: 15),
              title: "Продолжить")),
    );
  }
}
