import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/emailTextField.dart';
import 'package:gservice5/component/textField/passwordTextField.dart';
import 'package:gservice5/component/textField/phoneTextField.dart';
import 'package:gservice5/pages/auth/registration/registrationPage.dart';

class LoginPage extends StatefulWidget {
  final bool showBack;
  const LoginPage({super.key, required this.showBack});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  @override
  void dispose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  void verifyData() {
    String email = emailEditingController.text.trim();
    String password = passwordEditingController.text.trim();
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (email.isEmpty || password.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      if (emailValid) {
        postData();
      } else {
        SnackBarComponent().showErrorMessage("Неправильный email", context);
      }
    }
  }

  Future postData() async {
    showModalLoader(context);
    try {
      Response response = await dio.post("/login", queryParameters: {
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

  void showRegistrationPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegistrationPage()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        appBar: AppBar(
          leading: widget.showBack ? BackIconButton() : Container(),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                EmailTextField(textEditingController: emailEditingController),
                Divider(indent: 15),
                PhoneTextField(
                    onSubmitted: () {},
                    textEditingController: phoneEditingController,
                    autofocus: false),
                Divider(indent: 15),
                PasswordTextField(
                    textEditingController: passwordEditingController,
                    onSubmitted: () {
                      verifyData();
                    }),
                Divider(indent: 15),
                Button(
                    onPressed: () {
                      showRegistrationPage();
                    },
                    title: "Продолжить")
              ],
            )),
      ),
    );
  }
}
