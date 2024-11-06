import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/modal/registrationCountries.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/emailTextField.dart';
import 'package:gservice5/component/textField/phoneTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/auth/privacyPolicyWidget.dart';
import 'package:gservice5/pages/auth/verification/verificationEmailPage.dart';
import 'package:gservice5/pages/auth/verification/verificationPhonePage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

class IndividualExistsPage extends StatefulWidget {
  final Map data;
  const IndividualExistsPage({super.key, required this.data});

  @override
  State<IndividualExistsPage> createState() => _IndividualExistsPageState();
}

class _IndividualExistsPageState extends State<IndividualExistsPage> {
  List countries = [];
  Map currentCountry = {};
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController emailEditingController =
      TextEditingController(text: "mukhametzhan.tileubek@gmail.com");

  @override
  void initState() {
    getCountries();
    super.initState();
  }

  Future getCountries() async {
    try {
      Response response = await dio.get("/countries");
      print(response.data);
      if (response.data['success']) {
        currentCountry = response.data['data'][0];
        countries = response.data['data'];
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void showCountriesModal() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => RegistrationCountries(
            onPressed: savedAddressData, data: currentCountry));
  }

  void savedAddressData(value) {
    if (value != null) {
      setState(() {
        currentCountry = value;
      });
    }
  }

  void showLoginPage() {
    String title = currentCountry['phone_authenticate']
        ? phoneEditingController.text
        : emailEditingController.text;
    Navigator.pop(context, title);
    Navigator.pop(context, title);
  }

  void verifyData() {
    closeKeyboard();
    if (currentCountry['phone_authenticate']) {
      if (phoneEditingController.text.length == 18) {
        accountExists({"phone": getIntComponent(phoneEditingController.text)});
      } else {
        SnackBarComponent().showErrorMessage("Заполните все строки", context);
      }
    } else {
      if (emailEditingController.text.isEmpty) {
        SnackBarComponent().showErrorMessage("Заполните все строки", context);
      } else {
        final bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailEditingController.text);
        if (emailValid) {
          accountExists({"email": emailEditingController.text});
        } else {
          SnackBarComponent().showErrorMessage("Неправильный email", context);
        }
      }
    }
  }

  Future accountExists(Map<String, dynamic> param) async {
    showModalLoader(context);
    try {
      Response response = await dio.get("/user-exists", queryParameters: param);
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        if (!response.data['data']['is_exists']) {
          if (currentCountry['phone_authenticate']) {
            showVerificationPhonePage();
          } else {
            showVerificationEmailPage();
          }
        } else {
          if (currentCountry['phone_authenticate']) {
            SnackBarComponent()
                .showErrorMessage("На этом номере уже есть аккаунт", context);
          } else {
            SnackBarComponent()
                .showErrorMessage("На этом почте уже есть аккаунт", context);
          }
        }
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void showVerificationPhonePage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerificationPhonePage(userData: {
                  "country_id": currentCountry['id'],
                  "phone": phoneEditingController.text,
                  ...widget.data
                })));
  }

  void showVerificationEmailPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerificationEmailPage(
                    email: emailEditingController.text,
                    userData: {
                      "country_id": currentCountry['id'],
                      "email": emailEditingController.text,
                      ...widget.data
                    })));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        appBar: AppBar(title: Text("Регистрация"), leading: BackIconButton()),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Страна",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Divider(height: 8),
              countries.isEmpty
                  ? Shimmer.fromColors(
                      baseColor: Color(0xffD1D5DB),
                      highlightColor: Color(0xfff4f5f7),
                      child: Container(
                          height: 48,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Color(0xffF9FAFB),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1, color: Color(0xffE5E5EA)))),
                    )
                  : GestureDetector(
                      onTap: showCountriesModal,
                      child: Container(
                        height: 48,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Color(0xffF9FAFB),
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(width: 1, color: Color(0xffE5E5EA))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: SvgPicture.network(
                                  currentCountry['flag'],
                                  height: 14,
                                )),
                            Divider(indent: 8),
                            Expanded(
                              child: Text(currentCountry['title'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis)),
                            ),
                            SvgPicture.asset('assets/icons/down.svg')
                          ],
                        ),
                      ),
                    ),
              Divider(indent: 12),
              currentCountry['phone_authenticate'] ?? true
                  ? PhoneTextField(
                      textEditingController: phoneEditingController,
                      autofocus: false,
                      onSubmitted: () {})
                  : EmailTextField(
                      textEditingController: emailEditingController,
                      autofocus: false,
                      onSubmitted: () {}),
              Divider(indent: 12),
              SizedBox(
                height: 30,
                child: TextButton(
                  onPressed: showLoginPage,
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                          children: [
                        TextSpan(text: "Уже зарегистрированы? "),
                        TextSpan(
                            text: "Авторизуйтесь",
                            style:
                                TextStyle(color: ColorComponent.blue['700'])),
                      ])),
                ),
              ),
              Divider(indent: 8),
              Button(onPressed: verifyData, title: "Подтвердить"),
              Divider(indent: 8),
              PrivacyPolicyWidget()
            ],
          ),
        ),
      ),
    );
  }
}
