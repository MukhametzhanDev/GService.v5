import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/image/getImage/getLogoWidget.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/modal/cities.dart';
import 'package:gservice5/component/select/selectButton.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/passwordTextField.dart';
import 'package:gservice5/component/textField/repeatPasswordTextField.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RegistrationCustomerPage extends StatefulWidget {
  final Map data;
  const RegistrationCustomerPage({super.key, required this.data});

  @override
  State<RegistrationCustomerPage> createState() =>
      _RegistrationCustomerPageState();
}

class _RegistrationCustomerPageState extends State<RegistrationCustomerPage> {
  Map currentCity = {};
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController indentifierEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController repeatPasswordEditingController =
      TextEditingController();

  @override
  void dispose() {
    nameEditingController.dispose();
    indentifierEditingController.dispose();
    passwordEditingController.dispose();
    repeatPasswordEditingController.dispose();
    super.dispose();
  }

  Future postData() async {
    showModalLoader(context);
    try {
      Map<String, dynamic> param = {
        "role": "customer",
        "name": nameEditingController.text,
        "password": passwordEditingController.text,
        "city_id": currentCity['id'],
        "country_id": widget.data['country_id'],
        "email": widget.data['email']
      };
      Response response = await dio.post("/register", data: param);
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        ChangedToken().saveCustomerToken(response.data['data'], context);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void verifyData() {
    String name = nameEditingController.text.trim();
    String indentifier = indentifierEditingController.text.trim();
    String password = passwordEditingController.text.trim();
    String repeatPassword = repeatPasswordEditingController.text.trim();

    if (currentCity.isEmpty ||
        name.isEmpty ||
        indentifier.isEmpty ||
        password.isEmpty ||
        repeatPassword.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {}
  }

  void showCityModal() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => Cities(
            onPressed: savedcurrentCity, countryId: widget.data['country_id']));
  }

  void savedcurrentCity(value) {
    setState(() {
      currentCity = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        appBar:
            AppBar(leading: BackIconButton(), title: Text("Данные компании")),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(children: [
            GetLogoWidget(),
            Divider(height: 24),
            SelectButton(
                title: currentCity.isNotEmpty
                    ? currentCity['title']
                    : "Выберите город",
                active: currentCity.isNotEmpty,
                onPressed: showCityModal),
            Divider(indent: 8),
            TextField(
                controller: nameEditingController,
                style: TextStyle(fontSize: 14),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: "Название компании")),
            Divider(indent: 8),
            TextField(
                controller: indentifierEditingController,
                style: TextStyle(fontSize: 14),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "БИН")),
            Divider(indent: 8),
            PasswordTextField(
                textEditingController: passwordEditingController,
                onSubmitted: () {}),
            Divider(indent: 8),
            RepeatPasswordTextField(
                textEditingController: repeatPasswordEditingController,
                onSubmitted: () {}),
          ]),
        ),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: () {},
                padding: EdgeInsets.symmetric(horizontal: 15),
                title: "Подтвердить")),
      ),
    );
  }
}
