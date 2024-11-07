import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/emailTextField.dart';
import 'package:gservice5/component/textField/passwordTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/auth/privacyPolicyWidget.dart';
import 'package:gservice5/pages/auth/registration/accountType/getAccountTypePage.dart';

class LoginBusinessPage extends StatefulWidget {
  const LoginBusinessPage({super.key});

  @override
  State<LoginBusinessPage> createState() => _LoginBusinessPageState();
}

class _LoginBusinessPageState extends State<LoginBusinessPage>
    with SingleTickerProviderStateMixin {
  TextEditingController emailEditingController = TextEditingController(text: "mukhametzhan.tileubek@gmail.com");
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

  bool isNumeric(String text) {
    return RegExp(r'^\d+$').hasMatch(text);
  }

  Future postData(Map<String, dynamic> param) async {
    showModalLoader(context);
    // Map<String, dynamic> param = verifyParam();
    try {
      Response response = await dio.post("/business/login", queryParameters: {
        "email": emailEditingController.text,
        "password": passwordEditingController.text
      });
      print(response.data);
      Navigator.pop(context);
             if (response.statusCode==200) {

        ChangedToken().saveIndividualToken(response.data['data'], context);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void showRegistrationPage() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => GetAccountTypePage()))
        .then((value) {
      if (value != null) emailEditingController.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    onPressed: () {},
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
                          style: TextStyle(color: ColorComponent.blue['700'])),
                    ])),
              ),
            ),
            Divider(indent: 8),
            Button(onPressed: verifyData, title: "Подтвердить"),
            Divider(indent: 8),
            PrivacyPolicyWidget()
          ],
        ));
  }
}
