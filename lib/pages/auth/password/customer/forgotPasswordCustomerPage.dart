import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/auth/password/customer/forgotEmailPasswordCustomerPage.dart';
import 'package:gservice5/pages/auth/password/customer/forgotPhonePasswordCustomerPage.dart';

class ForgotPasswordCustomerPage extends StatefulWidget {
  final String title;
  const ForgotPasswordCustomerPage({super.key, required this.title});

  @override
  State<ForgotPasswordCustomerPage> createState() =>
      _ForgotPasswordCustomerPageState();
}

class _ForgotPasswordCustomerPageState
    extends State<ForgotPasswordCustomerPage> {
  TextEditingController textEditingController = TextEditingController();

  final analytics = GetIt.I<FirebaseAnalytics>();

  @override
  void initState() {
    textEditingController.text = widget.title;
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void verifyData() {
    String text = textEditingController.text.trim();
    if (text.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      if (isNumeric(text)) {
        if (text.length >= 10) {
          showForgotPhonePasswordCustomerPage();
        } else {
          SnackBarComponent()
              .showErrorMessage("Неправильный номер телефона", context);
        }
      } else {
        final bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(text);
        if (emailValid) {
          showForgotEmailPasswordCustomerPage();
        } else {
          SnackBarComponent().showErrorMessage("Неправильный email", context);
        }
      }
    }

    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.btnSendForgotPwd
    }).catchError((e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    });
  }

  void showForgotEmailPasswordCustomerPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForgotEmailPasswordCustomerPage(
                email: textEditingController.text)));
  }

  void showForgotPhonePasswordCustomerPage() {
    String text = textEditingController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForgotPhonePasswordCustomerPage(
                phone: "7${text.substring(text.length - 10)}")));
  }

  bool isNumeric(String text) {
    return RegExp(r'^\d+$').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackIconButton(), title: const Text("Забыли пароль")),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
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
            ],
          )),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: verifyData,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Отправить")),
    );
  }
}
