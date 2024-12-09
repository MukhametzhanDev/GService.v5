import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/emailTextField.dart';
import 'package:gservice5/component/textField/passwordTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/auth/password/business/forgotPasswordBusinessPage.dart';
import 'package:gservice5/pages/auth/privacyPolicyWidget.dart';
import 'package:gservice5/pages/auth/accountType/getAccountTypePage.dart';

class LoginBusinessPage extends StatefulWidget {
  final bool showBackButton;
  const LoginBusinessPage({super.key, required this.showBackButton});

  @override
  State<LoginBusinessPage> createState() => _LoginBusinessPageState();
}

class _LoginBusinessPageState extends State<LoginBusinessPage>
    with SingleTickerProviderStateMixin {
  TextEditingController emailEditingController =
      TextEditingController(text: "mukhametzhan.tileubek@gmail.com");
  TextEditingController passwordEditingController = TextEditingController();

  @override
  void dispose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  void verifyData() {
    String text = emailEditingController.text.trim();
    String password = passwordEditingController.text.trim();
    if (text.isEmpty || password.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      final bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(text);
      if (emailValid) {
        Map<String, dynamic> param = {"email": text};
        postData(param);
      } else {
        SnackBarComponent().showErrorMessage("Неправильный email", context);
      }
    }
  }

  Future postData(Map<String, dynamic> param) async {
    showModalLoader(context);
    // Map<String, dynamic> param = verifyParam();
    try {
      print({
        "email": emailEditingController.text,
        "password": passwordEditingController.text
      });
      Response response = await dio.post("/business/login", queryParameters: {
        "email": emailEditingController.text,
        "password": passwordEditingController.text
      });
      print(response.data);
      Navigator.pop(context);
      if (response.statusCode == 200 && response.data['success']) {
        if (response.data['data']['user']['role'] == "customer") {
          ChangedToken().saveCustomerToken(response.data['data'], context);
        } else {
          ChangedToken()
              .saveContractorToken(response.data['data'], "login", context);
        }
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void showRegistrationPage() {
    // Navigator.pushNamed(context, "GetAccountTypePage")
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => GetAccountTypePage()))
        .then((value) {
      if (value != null) emailEditingController.text = value;
    });
  }

  void showForgotPasswordIndividualPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForgotPasswordBusinessPage(
                email: emailEditingController.text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showBackButton
          ? AppBar(
              leadingWidth: 100,
              leading: BackTitleButton(
                  title: "Войти", onPressed: () => Navigator.pop(context)))
          : null,
      body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 10),
              SizedBox(
                  height: 48,
                  child: EmailTextField(
                      textEditingController: emailEditingController,
                      autofocus: false,
                      onSubmitted: () {})),
              Divider(indent: 15),
              PasswordTextField(
                  textEditingController: passwordEditingController,
                  onSubmitted: verifyData),
              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: showForgotPasswordIndividualPage,
                      child: Text(
                        "Забыли пароль?",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: ColorComponent.blue['700']),
                      ))),
              SizedBox(
                height: 30,
                child: TextButton(
                  onPressed: showRegistrationPage,
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                          children: [
                        TextSpan(text: "У вас нет аккаунта? "),
                        TextSpan(
                            text: "Зарегистрируйтесь",
                            style:
                                TextStyle(color: ColorComponent.blue['700'])),
                      ])),
                ),
              ),
              Divider(indent: 8),
              Button(onPressed: verifyData, title: "Подтвердить"),
              Divider(indent: 8),
              PrivacyPolicyWidget()
            ],
          )),
    );
  }
}
