import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/passwordTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/navigation/routes/app_router.gr.dart';
import 'package:gservice5/pages/auth/password/customer/forgotPasswordCustomerPage.dart';
import 'package:gservice5/pages/auth/privacyPolicyWidget.dart';
import 'package:gservice5/pages/auth/registration/customer/customerExistsPage.dart';
import 'package:auto_route/auto_route.dart';

class LoginPage extends StatefulWidget {
  final bool showBackButton;

  const LoginPage({super.key, required this.showBackButton});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  TextEditingController textEditingController =
      TextEditingController(text: "mukhametzhan.tileubek@gmail.com");
  TextEditingController passwordEditingController = TextEditingController();

  final analytics = FirebaseAnalytics.instance;

  @override
  void dispose() {
    textEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  void verifyData() async {
    await analytics.logEvent(
        name: GAEventName.buttonClick,
        parameters: {GAKey.buttonName: GAParams.btnLogin});

    String text = textEditingController.text.trim();
    String password = passwordEditingController.text.trim();
    if (text.isEmpty || password.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      if (isNumeric(text)) {
        if (text.length >= 10) {
          Map<String, dynamic> param = {
            "phone": "7${text.substring(text.length - 10)}"
          };
          postData(param);
        } else {
          SnackBarComponent()
              .showErrorMessage("Неправильный номер телефона", context);
        }
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
  }

  bool isNumeric(String text) {
    return RegExp(r'^\d+$').hasMatch(text);
  }

  Future postData(Map<String, dynamic> param) async {
    print(param);
    showModalLoader(context);
    // Map<String, dynamic> param = verifyParam();
    try {
      Response response = await dio.post("/login", queryParameters: {
        ...param,
        "password": passwordEditingController.text
      });
      print(response.data);
      Navigator.pop(context);
      if (response.statusCode == 200 && response.data['success']) {
        print(response.data);
        await ChangedToken().savedToken(response.data['data'], context);
        context.router.pushAndPopUntil(const CustomerBottomRoute(),
            predicate: (route) => false);

        await analytics.logLogin(
            loginMethod: param.containsKey('email') ? 'email' : 'phone');

        print('userID: ${response.data['data']['user']['id'].toString()}');

        var user = response.data['data']['user'];

        if (user['id'] != null) {
          await analytics.setUserId(id: user?['id'].toString());
        }

        await analytics.setDefaultEventParameters(
            {GAKey.role: user?['role']?['code_type'] ?? ''});
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
        MaterialPageRoute(builder: (context) => const CustomerExistsPage()));
    // Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => const GetAccountTypePage()))
    //     .then((value) {
    //   if (value != null) textEditingController.text = value;
    // });

    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.txtBtnRegister
    }).catchError((e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    });
  }

  void showForgotPasswordCustomerPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ForgotPasswordCustomerPage(title: textEditingController.text)));

    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.txtBtnForgotPassword
    }).catchError((e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Войти в GService.kz"),
          leading:
              widget.showBackButton ? const BackIconButton() : Container()),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 48,
                child: TextField(
                  onSubmitted: (value) {
                    verifyData();
                  },
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  style: const TextStyle(fontSize: 14, height: 1.1),
                  controller: textEditingController,
                  decoration: const InputDecoration(
                      hintText: "Email или номер телефона"),
                ),
              ),
              const Divider(indent: 15),
              PasswordTextField(
                  textEditingController: passwordEditingController,
                  onSubmitted: verifyData),
              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: showForgotPasswordCustomerPage,
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
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                          children: [
                        const TextSpan(text: "У вас нет аккаунта? "),
                        TextSpan(
                            text: "Зарегистрируйтесь",
                            style:
                                TextStyle(color: ColorComponent.blue['700'])),
                      ])),
                ),
              ),
              const Divider(indent: 8),
              Button(onPressed: verifyData, title: "Войти"),
              const Divider(indent: 8),
              const PrivacyPolicyWidget()
            ],
          )),
    );
  }
}
