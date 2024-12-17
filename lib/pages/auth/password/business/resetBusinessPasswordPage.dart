import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/passwordTextField.dart';
import 'package:gservice5/component/textField/repeatPasswordTextField.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';

class ResetBusinessPasswordPage extends StatefulWidget {
  final Map data;
  const ResetBusinessPasswordPage({super.key, required this.data});

  @override
  State<ResetBusinessPasswordPage> createState() =>
      _ResetBusinessPasswordPageState();
}

class _ResetBusinessPasswordPageState extends State<ResetBusinessPasswordPage> {
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
      Response response = await dio.post("/business/password-reset",
          data: param,
          options: Options(headers: {
            "authorization": "Bearer ${widget.data['user_token']}"
          }));
      print(response.data);
      if (response.statusCode == 200 && response.data['success']) {
        if (widget.data['role'] == "cusomter") {
          ChangedToken().saveCustomerToken(widget.data, context);
        } else {
          ChangedToken()
              .saveContractorToken(widget.data, "login", context);
        }
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
        appBar: AppBar(leading: BackIconButton(), title: const Text('')),
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
