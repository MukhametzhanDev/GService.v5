import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/map/getMapAddressPage.dart';
import 'package:gservice5/component/select/select.dart';
import 'package:gservice5/component/select/selectButton.dart';
import 'package:gservice5/component/select/selectVerifyData.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';

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

  void verifyData() {
    if (country.isEmpty || city.isEmpty || address.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      showPage();
    }
  }

  void showGetAddressPage() {
    if (city.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните строку 'Город'", context);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GetMapAddressPage(
                  onSavedData: (value) {
                    address = value;
                    setState(() {});
                  },
                  cityData: city)));
    }
  }

  void savedData() {
    Map createData = CreateData.data;
    createData['country_id'] = country['id'];
    createData['city_id'] = city['id'];
    createData.addAll(address);
  }

  void showPage() {
    savedData();
    widget.nextPage();
  }

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
          SelectVerifyData(
              title: "Город",
              onChanged: (value) {
                city = value;
                setState(() {});
              },
              pagination: false,
              api: "/cities?country_id=${country['id']}",
              showErrorMessage:
                  country.isEmpty ? "Заполните строку 'Страна'" : ""),
          Divider(),
          SelectButton(
              title: address.isEmpty ? "Введите адрес" : address['address'],
              active: address.isNotEmpty,
              onPressed: showGetAddressPage)
        ]),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: verifyData,
              padding: EdgeInsets.symmetric(horizontal: 15),
              title: "Продолжить")),
    );
  }
}
