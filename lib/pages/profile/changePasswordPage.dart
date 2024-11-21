import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/passwordTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  void verifyData() {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final repeatPassword = repeatPasswordController.text.trim();

    if (oldPassword.length < 5 ||
        newPassword.length < 5 ||
        repeatPassword.length < 5) {
      SnackBarComponent()
          .showErrorMessage("Пожалуйста заполните все поля", context);
    } else if (newPassword != repeatPassword) {
      SnackBarComponent().showErrorMessage("Пароли должны совпадать", context);
    } else {
      SnackBarComponent().showDoneMessage("DONE", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          leading: BackIconButton(),
          title: Text("Смена пароля")),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            PasswordTextField(
                textEditingController: oldPasswordController,
                onSubmitted: () {},
                hintText: "Старый пароль"),
            Divider(height: 20),
            PasswordTextField(
                textEditingController: newPasswordController,
                onSubmitted: () {},
                hintText: "Придумайте пароль"),
            Divider(height: 8),
            Text("Пароль должен содержать минимум 8 символов",
                style:
                    TextStyle(fontSize: 12, color: ColorComponent.gray['500'])),
            Divider(height: 20),
            PasswordTextField(
                textEditingController: repeatPasswordController,
                onSubmitted: () {},
                hintText: "Повторите новый пароль")
          ])),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: verifyData,
              backgroundColor: ColorComponent.mainColor,
              titleColor: Colors.black,
              icon: null,
              padding: EdgeInsets.only(bottom: 8, top: 8, right: 16, left: 16),
              widthIcon: null,
              title: "Сохранить")),
    );
  }
}
