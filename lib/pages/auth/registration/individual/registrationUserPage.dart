import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/modal/cities.dart';
import 'package:gservice5/component/select/selectButton.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/passwordTextField.dart';
import 'package:gservice5/component/textField/repeatPasswordTextField.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RegistrationIndividualPage extends StatefulWidget {
  final Map data;
  const RegistrationIndividualPage({super.key, required this.data});

  @override
  State<RegistrationIndividualPage> createState() => _RegistrationIndividualPageState();
}

class _RegistrationIndividualPageState extends State<RegistrationIndividualPage> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController repeatPasswordEditingController =
      TextEditingController();
  Map currentCity = {};

  Future postData() async {
    showModalLoader(context);

    try {
      Map<String, dynamic> param = {
        "name": nameEditingController.text,
        "password": passwordEditingController.text,
        "city_id": currentCity['id'],
        "country_id": widget.data['country_id'],
        "phone": getIntComponent(widget.data['phone']).toString()
      };
      Response response = await dio.post("/register", data: param);
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        ChangedToken().saveIndividualToken(response.data['data'], context);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      // print(e)
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void verifyData() {
    String name = nameEditingController.text.trim();
    String password = passwordEditingController.text.trim();
    String repeatPassword = repeatPasswordEditingController.text.trim();
    if (name.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      if (password.length < 5) {
        SnackBarComponent()
            .showErrorMessage("Пароль должен быть больше 5 символов", context);
      } else {
        if (password == repeatPassword) {
          postData();
        } else {
          SnackBarComponent().showErrorMessage("Пароль не совпадают", context);
        }
      }
    }
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    passwordEditingController.dispose();
    repeatPasswordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        appBar: AppBar(title: Text("Регистрация"), leading: BackIconButton()),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          child: Column(
            children: [
              TextField(
                  autofocus: true,
                  style: TextStyle(fontSize: 14, height: 1.1),
                  decoration: InputDecoration(hintText: "ФИО"),
                  controller: nameEditingController),
              Divider(indent: 8),
              SelectButton(
                  title: currentCity.isEmpty
                      ? "Выберите город"
                      : currentCity['title'],
                  active: currentCity.isNotEmpty,
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) => Cities(
                            onPressed: (value) {
                              currentCity = value;
                              setState(() {});
                            },
                            countryId: widget.data['country_id']));
                  }),
              Divider(indent: 8),
              PasswordTextField(
                  textEditingController: passwordEditingController,
                  onSubmitted: () {}),
              Divider(indent: 8),
              RepeatPasswordTextField(
                  textEditingController: repeatPasswordEditingController,
                  onSubmitted: verifyData)
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: verifyData,
                padding: EdgeInsets.symmetric(horizontal: 15),
                title: "Продолжить")),
      ),
    );
  }
}
