import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gservice5/component/button/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/modal/cities.dart';
import 'package:gservice5/component/select/selectButton.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/passwordTextField.dart';
import 'package:gservice5/component/textField/phoneTextField.dart';
import 'package:gservice5/component/textField/repeatPasswordTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/address/getAddressWidget.dart';
import 'package:gservice5/pages/auth/registration/accountType/typeAccountModal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RegistrationResidentKzWidget extends StatefulWidget {
  final String phone;
  const RegistrationResidentKzWidget({super.key, required this.phone});

  @override
  State<RegistrationResidentKzWidget> createState() =>
      _RegistrationResidentKzWidgetState();
}

class _RegistrationResidentKzWidgetState
    extends State<RegistrationResidentKzWidget>
    with AutomaticKeepAliveClientMixin {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController repeatPasswordEditingController =
      TextEditingController();
  Map address = {};

  @override
  void initState() {
    phoneEditingController.text = widget.phone;
    super.initState();
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    phoneEditingController.dispose();
    passwordEditingController.dispose();
    repeatPasswordEditingController.dispose();
    super.dispose();
  }

  void verifyData() {
    String name = nameEditingController.text.trim();
    String phone = phoneEditingController.text.trim();
    String password = passwordEditingController.text.trim();
    String repeatPassword = passwordEditingController.text.trim();
    if (name.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        address.isEmpty ||
        repeatPassword.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      if (phone.length == 18) {
        postData();
      } else {
        SnackBarComponent()
            .showErrorMessage("Неправильный номер телефона", context);
      }
    }
  }

  Future postData() async {
    showModalLoader(context);
    try {
      Response response = await dio.post("/register", queryParameters: {
        "name": nameEditingController.text,
        "phone": getIntComponent(phoneEditingController.text),
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
            Cities(onPressed: savedAddressData, countryData: address));
  }

  void savedAddressData(value) {
    if (value != null) {
      setState(() {
        address = value;
      });
    }
  }

  void showModalTypeUser() {
    showCupertinoModalBottomSheet(
        context: context, builder: (context) => TypeAccountModal());
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
                SelectButton(
                    title: "Тип личного кабинета",
                    active: false,
                    onPressed: showModalTypeUser),
                const Divider(indent: 15),
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
                PhoneTextField(
                    onSubmitted: () {},
                    textEditingController: phoneEditingController,
                    autofocus: false),
                const Divider(indent: 15),
                GetAddressWidget(
                    onPressed: showModal, data: address, showCountry: false),
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
