import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/emailTextField.dart';
import 'package:gservice5/component/textField/phoneTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class UserExistsPage extends StatefulWidget {
  final bool showBack;
  const UserExistsPage({super.key, required this.showBack});

  @override
  State<UserExistsPage> createState() => _UserExistsPageState();
}

class _UserExistsPageState extends State<UserExistsPage>
    with SingleTickerProviderStateMixin {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  bool byEmail = true;

  @override
  void dispose() {
    emailEditingController.dispose();
    phoneEditingController.dispose();
    super.dispose();
  }

  Future postData() async {
    try {
      Map<String, dynamic> param = byEmail ? {} : {};
      Response response =
          await dio.post("/user-exists", queryParameters: param);
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void verifyData() {
    String email = emailEditingController.text.trim();
    String phone = phoneEditingController.text.trim();
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (byEmail) {
      if (emailValid) {
        postData();
      } else {
        SnackBarComponent().showErrorMessage("Неправильный email", context);
      }
    } else {
      if (phone.length == 18) {
        postData();
      } else {
        SnackBarComponent()
            .showErrorMessage("Неправильный номер телефона", context);
      }
    }
  }

  void changedByEmail(bool value) {
    byEmail = value;
    setState(() {});
    closeKeyboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 50),
            child: Container(
              height: 42,
              padding: EdgeInsets.all(4),
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Color(0xfff4f4f4),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      changedByEmail(true);
                    },
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: byEmail
                              ? ColorComponent.mainColor
                              : Colors.transparent),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/mailBox.svg'),
                          Divider(indent: 4),
                          Text("Через почту",
                              style: TextStyle(fontWeight: FontWeight.w500))
                        ],
                      ),
                    ),
                  )),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      changedByEmail(false);
                    },
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: !byEmail
                              ? ColorComponent.mainColor
                              : Colors.transparent),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/phone.svg', width: 16),
                          Divider(indent: 4),
                          Text("По телефону",
                              style: TextStyle(fontWeight: FontWeight.w500))
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            )),
      ),
      body: byEmail
          ? SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  EmailTextField(
                      textEditingController: emailEditingController,
                      onSubmitted: verifyData)
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  PhoneTextField(
                      onSubmitted: verifyData,
                      textEditingController: phoneEditingController,
                      autofocus: false)
                ],
              ),
            ),
    );
  }
}
