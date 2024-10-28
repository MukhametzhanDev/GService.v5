import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/emailTextField.dart';
import 'package:gservice5/component/textField/passwordTextField.dart';
import 'package:gservice5/component/textField/phoneTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/auth/registration/registrationPage.dart';

class LoginPage extends StatefulWidget {
  final String email;
  final String phone;
  final bool byPhone;
  const LoginPage(
      {super.key,
      required this.email,
      required this.phone,
      required this.byPhone});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  bool byPhone = true;
  late TabController tabController;

  @override
  void initState() {
    byPhone = widget.byPhone;
    emailEditingController.text = widget.email;
    phoneEditingController.text = widget.phone;
    tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.byPhone ? 0 : 1);
    super.initState();
  }

  @override
  void dispose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  void verifyData() {
    String email = emailEditingController.text.trim();
    String password = passwordEditingController.text.trim();
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (email.isEmpty || password.isEmpty) {
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
    Map<String, dynamic> param = verifyParam();
    try {
      Response response = await dio.post("/login", queryParameters: param);
      if (response.data['success']) {
        ChangedToken().saveToken(response.data['data'], context);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
    Navigator.pop(context);
  }

  Map<String, dynamic> verifyParam() {
    if (byPhone) {
      return {
        "email": emailEditingController.text,
        "password": passwordEditingController.text
      };
    } else {
      return {
        "phone": getIntComponent(phoneEditingController.text),
        "password": passwordEditingController.text
      };
    }
  }

  void showRegistrationPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                RegistrationPage(email: "", phone: "", byPhone: false)));
  }

  void changedbyPhone(bool value) {
    byPhone = value;
    setState(() {});
    closeKeyboard();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Регистрация"),
          leading: const BackIconButton(),
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width - 30, 40),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xfff4f4f4)),
                width: MediaQuery.of(context).size.width - 30,
                child: TabBar(
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 0.0,
                  labelColor: Colors.black,
                  labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  unselectedLabelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border(
                      bottom: BorderSide(
                        color: ColorComponent.mainColor,
                        width: 40.0,
                      ),
                    ),
                  ),
                  tabs: [
                    Tab(text: 'Резидент Казахстана'),
                    Tab(text: 'Нерезидент Казахстана'),
                  ],
                ),
              )),
        ),
        body: TabBarView(controller: tabController, children: [
          SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PhoneTextField(
                      onSubmitted: () {},
                      textEditingController: phoneEditingController,
                      autofocus: false),
                  Divider(indent: 15),
                  PasswordTextField(
                      textEditingController: passwordEditingController,
                      onSubmitted: verifyData),
                  Divider(height: 7),
                  TextButton(onPressed: () {}, child: Text("Забыли пароль"))
                ],
              )),
          SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EmailTextField(
                    textEditingController: emailEditingController,
                    onSubmitted: () {},
                  ),
                  Divider(indent: 15),
                  PasswordTextField(
                      textEditingController: passwordEditingController,
                      onSubmitted: verifyData),
                  Divider(height: 7),
                  TextButton(onPressed: () {}, child: Text("Забыли пароль"))
                ],
              ))
        ]),
        // SingleChildScrollView(
        //     padding: EdgeInsets.all(15),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         byPhone
        //             ? Column(
        //                 children: [
        //                   EmailTextField(
        //                     textEditingController: emailEditingController,
        //                     onSubmitted: () {},
        //                   ),
        //                   Divider(indent: 15),
        //                   PasswordTextField(
        //                       textEditingController: passwordEditingController,
        //                       onSubmitted: verifyData),
        //                 ],
        //               )
        //             : Column(
        //                 children: [
        //                   PhoneTextField(
        //                       onSubmitted: () {},
        //                       textEditingController: phoneEditingController,
        //                       autofocus: false),
        //                   Divider(indent: 15),
        //                   PasswordTextField(
        //                       textEditingController: passwordEditingController,
        //                       onSubmitted: verifyData),
        //                   Divider(indent: 15),
        //                 ],
        //               ),
        //         TextButton(
        //             onPressed: () {},
        //             child: Text("Забыли пароль",
        //                 style: TextStyle(color: ColorComponent.blue['500'])))
        //       ],
        //     )),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: verifyData,
                padding: EdgeInsets.symmetric(horizontal: 15),
                title: "Продолжить")),
      ),
    );
  }
}
