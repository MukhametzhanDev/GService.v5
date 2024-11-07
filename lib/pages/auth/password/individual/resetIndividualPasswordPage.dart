import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/passwordTextField.dart';
import 'package:gservice5/component/textField/repeatPasswordTextField.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';

class ResetIndividualPasswordPage extends StatefulWidget {
  const ResetIndividualPasswordPage({super.key});

  @override
  State<ResetIndividualPasswordPage> createState() =>
      _ResetIndividualPasswordPageState();
}

class _ResetIndividualPasswordPageState
    extends State<ResetIndividualPasswordPage> {
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController repeatPasswordEditingController =
      TextEditingController();

  @override
  void dispose() {
    passwordEditingController.dispose();
    repeatPasswordEditingController.dispose();
    super.dispose();
  }

  void postData() async {
    showModalLoader(context);
    try {
      Map<String, dynamic> param = {
        "password": passwordEditingController.text,
        "password_confirmation": repeatPasswordEditingController.text
      };
      Response response = await dio.post("/password-reset", data: param);
      print(response.data);
      if (response.statusCode == 200 && response.data['success']) {
        Navigator.pop(context);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
      Navigator.pop(context);
    } catch (e) {
      // print(e)
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void verifyData() {
    String password = passwordEditingController.text.trim();
    String repeatPassword = repeatPasswordEditingController.text.trim();
    if (password.isEmpty || repeatPassword.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      if (password.length < 6) {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        appBar: AppBar(leading: BackIconButton(), title: Text('')),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              PasswordTextField(
                  textEditingController: passwordEditingController,
                  onSubmitted: () {}),
              Divider(indent: 8),
              RepeatPasswordTextField(
                  textEditingController: repeatPasswordEditingController,
                  onSubmitted: postData)
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: verifyData,
                padding: EdgeInsets.symmetric(horizontal: 15),
                title: "Подтвердить")),
      ),
    );
  }
}
