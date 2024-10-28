import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/modal/countries.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/emailTextField.dart';
import 'package:gservice5/component/textField/passwordTextField.dart';
import 'package:gservice5/component/textField/repeatPasswordTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/address/getAddressWidget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RegistrationNonResidentWidget extends StatefulWidget {
  final String email;
  const RegistrationNonResidentWidget({super.key, required this.email});

  @override
  State<RegistrationNonResidentWidget> createState() =>
      _RegistrationNonResidentWidgetState();
}

class _RegistrationNonResidentWidgetState
    extends State<RegistrationNonResidentWidget>
    with AutomaticKeepAliveClientMixin {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController repeatPasswordEditingController =
      TextEditingController();
  Map address = {};
  bool byPhone = true;

  @override
  void initState() {
    emailEditingController.text = widget.email;
    super.initState();
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    emailEditingController.dispose();
    passwordEditingController.dispose();
    repeatPasswordEditingController.dispose();
    super.dispose();
  }

  void verifyData() {
    String name = nameEditingController.text.trim();
    String email = emailEditingController.text.trim();
    String password = passwordEditingController.text.trim();
    String repeatPassword = passwordEditingController.text.trim();
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (email.isEmpty ||
        name.isEmpty ||
        password.isEmpty ||
        address.isEmpty ||
        repeatPassword.isEmpty) {
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
      Response response = await dio.post("/register", queryParameters: {
        "name": nameEditingController.text,
        "email": emailEditingController.text,
        "password": passwordEditingController.text,
        "city_id": address['city']['id']
      });
      Navigator.pop(context);
      if (response.data['success']) {
        ChangedToken().saveToken(response.data['data'], context);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void showModal() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) =>
            Countries(onPressed: savedAddressData, data: address));
  }

  void savedAddressData(value) {
    if (value != null) {
      setState(() {
        address = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 48,
                    child: AutofillGroup(
                      child: TextField(
                        controller: nameEditingController,
                        style: TextStyle(fontSize: 14, height: 1.1),
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.name,
                        autofillHints: [AutofillHints.name],
                        decoration: InputDecoration(hintText: "ФИО"),
                      ),
                    )),
                const Divider(indent: 15),
                EmailTextField(
                    textEditingController: emailEditingController,
                    onSubmitted: () {}),
                const Divider(indent: 15),
                GetAddressWidget(
                    onPressed: showModal, data: address, showCountry: true),
                const Divider(indent: 15),
                PasswordTextField(
                    textEditingController: passwordEditingController,
                    onSubmitted: () {
                      verifyData();
                    }),
                Divider(height: 8),
                Text("Пароль должен содержать минимум 6 символов",
                    style: TextStyle(
                        fontSize: 12, color: ColorComponent.gray['500'])),
                const Divider(indent: 15),
                RepeatPasswordTextField(
                    textEditingController: repeatPasswordEditingController,
                    onSubmitted: verifyData),
                const Divider(height: 24),
                Button(onPressed: verifyData, title: "Продолжить")
              ],
            )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
