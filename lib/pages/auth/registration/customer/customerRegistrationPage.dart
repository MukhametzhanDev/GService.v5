import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
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
import 'package:gservice5/navigation/routes/app_router.gr.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:auto_route/auto_route.dart';

class CusomterRegistrationPage extends StatefulWidget {
  final Map data;
  final bool isPhone;
  const CusomterRegistrationPage(
      {super.key, required this.data, required this.isPhone});

  @override
  State<CusomterRegistrationPage> createState() =>
      _CusomterRegistrationPageState();
}

class _CusomterRegistrationPageState extends State<CusomterRegistrationPage> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController repeatPasswordEditingController =
      TextEditingController();
  Map currentCity = {};

  Future postData() async {
    showModalLoader(context);
    try {
      Response response = await dio.post("/register", data: getParam());
      print(response.data);
      Navigator.pop(context);
      if (response.statusCode == 200) {
        ChangedToken().savedToken(response.data['data'], context);
        context.router.pushAndPopUntil(const CustomerBottomRoute(),
            predicate: (route) => false);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  Map getParam() {
    Map<String, dynamic> param = {
      "name": nameEditingController.text,
      "password": passwordEditingController.text,
      "city_id": currentCity['id'],
      "country_id": widget.data['country_id'],
    };
    if (widget.isPhone) {
      param.addAll({"phone": getIntComponent(widget.data['phone']).toString()});
    } else {
      param.addAll({"email": widget.data['email']});
    }
    return param;
  }

  void verifyData() {
    String name = nameEditingController.text.trim();
    String password = passwordEditingController.text.trim();
    String repeatPassword = repeatPasswordEditingController.text.trim();
    if (name.isEmpty ||
        password.isEmpty ||
        repeatPassword.isEmpty ||
        currentCity.isEmpty) {
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
        appBar: AppBar(
            title: const Text("Регистрация"), leading: const BackIconButton()),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          child: Column(
            children: [
              TextField(
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(fontSize: 14, height: 1.1),
                  decoration: const InputDecoration(hintText: "ФИО"),
                  controller: nameEditingController),
              const Divider(indent: 8),
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
              const Divider(indent: 8),
              PasswordTextField(
                  textEditingController: passwordEditingController,
                  onSubmitted: () {}),
              const Divider(indent: 8),
              RepeatPasswordTextField(
                  textEditingController: repeatPasswordEditingController,
                  onSubmitted: verifyData)
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: postData,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                title: "Продолжить")),
      ),
    );
  }
}
