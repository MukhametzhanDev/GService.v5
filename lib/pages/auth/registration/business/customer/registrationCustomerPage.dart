import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/image/getImage/getLogoWidget.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/modal/cities.dart';
import 'package:gservice5/component/select/selectButton.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/passwordTextField.dart';
import 'package:gservice5/component/textField/repeatPasswordTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RegistrationCustomerPage extends StatefulWidget {
  final Map data;
  const RegistrationCustomerPage({super.key, required this.data});

  @override
  State<RegistrationCustomerPage> createState() =>
      _RegistrationCustomerPageState();
}

class _RegistrationCustomerPageState extends State<RegistrationCustomerPage> {
  Map currentCity = {};
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController identifierEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController repeatPasswordEditingController =
      TextEditingController();
  String imagePath = "";

  @override
  void dispose() {
    nameEditingController.dispose();
    identifierEditingController.dispose();
    passwordEditingController.dispose();
    repeatPasswordEditingController.dispose();
    super.dispose();
  }

  Future postImage() async {
    showModalLoader(context);
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(imagePath,
            filename: imagePath.split('/').last)
      });
      Response response = await dio.post("/image/avatar", data: formData);
      print(response.data);
      Navigator.pop(context);
      if (response.statusCode == 200) {
        postData(response.data['data']);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  Future postData(String url) async {
    showModalLoader(context);
    print(widget.data);
    try {
      Map<String, dynamic> param = {
        "role": "customer",
        "name": nameEditingController.text,
        "password": passwordEditingController.text,
        "city_id": currentCity['id'],
        "country_id": widget.data['country_id'],
        "email": widget.data['email'],
        "avatar": url,
        "identifier": identifierEditingController.text
      };
      Response response = await dio.post("/business/register", data: param);
      print(response.data);
      Navigator.pop(context);
      if (response.statusCode == 200) {
        ChangedToken().saveCustomerToken(response.data['data'], context);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void verifyData() {
    String name = nameEditingController.text.trim();
    String indentifier = identifierEditingController.text.trim();
    String password = passwordEditingController.text.trim();
    String repeatPassword = repeatPasswordEditingController.text.trim();
    if (imagePath.isEmpty ||
        currentCity.isEmpty ||
        name.isEmpty ||
        indentifier.isEmpty ||
        password.isEmpty ||
        repeatPassword.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      postImage();
    }
  }

  void showCityModal() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => Cities(
            onPressed: savedcurrentCity, countryId: widget.data['country_id']));
  }

  void savedcurrentCity(value) {
    setState(() {
      currentCity = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        appBar:
            AppBar(leading: const BackIconButton(), title: const Text("Данные компании")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            GetLogoWidget(onChanged: (path) {
              imagePath = path;
              setState(() {});
            }),
            const Divider(height: 24),
            SelectButton(
                title: currentCity.isNotEmpty
                    ? currentCity['title']
                    : "Выберите город",
                active: currentCity.isNotEmpty,
                onPressed: showCityModal),
            const Divider(indent: 8),
            TextField(
                controller: nameEditingController,
                style: const TextStyle(fontSize: 14),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(hintText: "Название компании")),
            const Divider(indent: 8),
            TextField(
                controller: identifierEditingController,
                style: const TextStyle(fontSize: 14),
                keyboardType: TextInputType.number,
                maxLength: 12,
                decoration: InputDecoration(
                    hintText: "БИН",
                    helperStyle: TextStyle(color: ColorComponent.gray['500']))),
            const Divider(indent: 8),
            PasswordTextField(
                textEditingController: passwordEditingController,
                onSubmitted: () {}),
            const Divider(indent: 8),
            RepeatPasswordTextField(
                textEditingController: repeatPasswordEditingController,
                onSubmitted: () {}),
          ]),
        ),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: () => verifyData(),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                title: "Подтвердить")),
      ),
    );
  }
}
