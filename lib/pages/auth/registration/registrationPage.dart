import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gservice5/component/button/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/emailTextField.dart';
import 'package:gservice5/component/textField/passwordTextField.dart';
import 'package:gservice5/component/textField/phoneTextField.dart';
import 'package:gservice5/component/textField/repeatPasswordTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/address/getAddressWidget.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController repeatPasswordEditingController =
      TextEditingController();

  @override
  void dispose() {
    nameEditingController.dispose();
    emailEditingController.dispose();
    phoneEditingController.dispose();
    passwordEditingController.dispose();
    repeatPasswordEditingController.dispose();
    super.dispose();
  }

  void verifyData() {
    String name = nameEditingController.text.trim();
    String phone = phoneEditingController.text.trim();
    String email = emailEditingController.text.trim();
    String password = passwordEditingController.text.trim();
    String repeatPassword = passwordEditingController.text.trim();
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (email.isEmpty ||
        name.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        repeatPassword.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      if (emailValid) {
        if (phone.length == 18) {
          postData();
        } else {
          SnackBarComponent()
              .showErrorMessage("Неправильный номер телефона", context);
        }
      } else {
        SnackBarComponent().showErrorMessage("Неправильный email", context);
      }
    }
  }

  Future postData() async {
    showModalLoader(context);
    try {
      Response response = await dio.post("/register", queryParameters: {
        "name": nameEditingController.text,
        "phone": getIntComponent(phoneEditingController.text),
        "email": emailEditingController.text,
        "password": passwordEditingController.text
      });
      if (response.data['success']) {
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        appBar: AppBar(leading: const BackIconButton()),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 48,
                    child: AutofillGroup(
                      child: const TextField(
                        keyboardType: TextInputType.name,
                        autofillHints: [AutofillHints.name],
                        decoration: InputDecoration(hintText: "ФИО"),
                      ),
                    )),
                const Divider(indent: 15),
                EmailTextField(textEditingController: emailEditingController),
                const Divider(indent: 15),
                PhoneTextField(
                    onSubmitted: () {},
                    textEditingController: phoneEditingController,
                    autofocus: false),
                const Divider(indent: 15),
                GetAddressWidget(),
                const Divider(indent: 15),
                PasswordTextField(
                    textEditingController: passwordEditingController,
                    onSubmitted: () {
                      verifyData();
                    }),
                Divider(height: 8),
                Text("Пароль должен содержать минимум 6 символов",
                    style: TextStyle(
                        fontSize: 12, color: ColorComponent.gray['500'])),
                const Divider(indent: 15),
                RepeatPasswordTextField(
                    textEditingController: repeatPasswordEditingController,
                    onSubmitted: () {}),
                const Divider(height: 24),
                Button(
                    onPressed: () {
                      verifyData();
                    },
                    title: "Продолжить")
              ],
            )),
      ),
    );
  }
}
