import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/auth/password/business/forgotEmailPasswordBusinessPage.dart';

class ForgotPasswordBusinessPage extends StatefulWidget {
  final String email;
  const ForgotPasswordBusinessPage({super.key, required this.email});

  @override
  State<ForgotPasswordBusinessPage> createState() =>
      _ForgotPasswordBusinessPageState();
}

class _ForgotPasswordBusinessPageState
    extends State<ForgotPasswordBusinessPage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = widget.email;
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

  void showForgotEmailPasswordCustomerPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForgotEmailPasswordBusinessPage(
                email: textEditingController.text)));
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
