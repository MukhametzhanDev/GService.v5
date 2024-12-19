import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/image/getImage/getLogoWidget.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/passwordTextField.dart';
import 'package:gservice5/component/textField/phoneTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  void verifyEmployee() {
    final name = nameEditingController.text.trim();
    final phone = phoneEditingController.text.trim();
    final password = passwordEditingController.text.trim();

    if (name.isEmpty || phone.isEmpty || password.length < 5) {
      SnackBarComponent()
          .showErrorMessage("Пожалуйста заполните все поля", context);
    } else {
      Navigator.pop(context, {
        "name": name,
        "phone": phone,
        "image":
            "https://images.unsplash.com/photo-1623582854588-d60de57fa33f?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Добавить сотрудника"),
          centerTitle: false,
          actions: [
            CloseIconButton(
                iconColor: ColorComponent.gray['400'], padding: true)
          ]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Divider(height: 16),
            GetLogoWidget(onChanged: (path) {}),
            const Divider(height: 30),
            const Text("ФИО",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const Divider(height: 8),
            SizedBox(
                height: 48,
                child: TextField(
                    onSubmitted: (value) {},
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 14, height: 1.1),
                    controller: nameEditingController,
                    decoration: const InputDecoration(hintText: "ФИО"))),
            const Divider(height: 12),
            const Text("Номер телефона",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const Divider(height: 8),
            PhoneTextField(
                textEditingController: phoneEditingController,
                autofocus: false,
                onSubmitted: () {}),
            const Divider(height: 12),
            const Text("Придумайте пароль",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const Divider(height: 8),
            PasswordTextField(
                hintText: "Пароль",
                textEditingController: passwordEditingController,
                onSubmitted: () {}),
            const Divider(height: 8),
            Text("Пароль должен содержать минимум 8 символов",
                style:
                    TextStyle(fontSize: 12, color: ColorComponent.gray['500']))
          ])),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: verifyEmployee,
              backgroundColor: ColorComponent.mainColor,
              titleColor: Colors.black,
              icon: null,
              padding: const EdgeInsets.only(bottom: 8, top: 8, right: 16, left: 16),
              widthIcon: null,
              title: "Сохранить")),
    );
  }
}
