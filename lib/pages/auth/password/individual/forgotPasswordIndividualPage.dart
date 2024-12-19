import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/auth/password/individual/forgotEmailPasswordIndividualPage.dart';
import 'package:gservice5/pages/auth/password/individual/forgotPhonePasswordIndividualPage.dart';

class ForgotPasswordIndividualPage extends StatefulWidget {
  final String title;
  const ForgotPasswordIndividualPage({super.key, required this.title});

  @override
  State<ForgotPasswordIndividualPage> createState() =>
      _ForgotPasswordIndividualPageState();
}

class _ForgotPasswordIndividualPageState
    extends State<ForgotPasswordIndividualPage> {
  TextEditingController textEditingController = TextEditingController();

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
          showForgotPhonePasswordIndividualPage();
        } else {
          SnackBarComponent()
              .showErrorMessage("Неправильный номер телефона", context);
        }
      } else {
        final bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(text);
        if (emailValid) {
          showForgotEmailPasswordIndividualPage();
        } else {
          SnackBarComponent().showErrorMessage("Неправильный email", context);
        }
      }
    }
  }

  void showForgotEmailPasswordIndividualPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForgotEmailPasswordIndividualPage(
                email: textEditingController.text)));
  }

  void showForgotPhonePasswordIndividualPage() {
    String text = textEditingController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForgotPhonePasswordIndividualPage(
                phone: "7${text.substring(text.length - 10)}")));
  }

  bool isNumeric(String text) {
    return RegExp(r'^\d+$').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackIconButton(), title: const Text("Забыли пароль")),
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
                  decoration:
                      const InputDecoration(hintText: "Email или номер телефона"),
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
