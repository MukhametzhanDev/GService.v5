import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/modal/registrationCountries.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/emailTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/auth/privacyPolicyWidget.dart';
import 'package:gservice5/pages/auth/verification/verificationEmailPage.dart';
import 'package:gservice5/pages/auth/verification/verificationPhonePage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

class BusinessExistsPage extends StatefulWidget {
  final Map data;
  const BusinessExistsPage({super.key, required this.data});

  @override
  State<BusinessExistsPage> createState() => _BusinessExistsPageState();
}

class _BusinessExistsPageState extends State<BusinessExistsPage> {
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
      if (response.statusCode == 200) {
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
    String title = emailEditingController.text;
    Navigator.pop(context, title);
    Navigator.pop(context, title);
  }

  void verifyData() {
    closeKeyboard();
    if (emailEditingController.text.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      final bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailEditingController.text);
      if (emailValid) {
        accountExists();
      } else {
        SnackBarComponent().showErrorMessage("Неправильный email", context);
      }
    }
  }

  Future accountExists() async {
    showModalLoader(context);
    try {
      Response response = await dio.get("/company-exists",
          queryParameters: {"email": emailEditingController.text});
      print(response.data);
      Navigator.pop(context);
      if (response.statusCode == 200) {
        if (!response.data['data']['is_exists']) {
          showVerificationEmailPage();
        } else {
          SnackBarComponent()
              .showErrorMessage("На этом почте уже есть аккаунт", context);
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
                      "phone": phoneEditingController.text,
                      ...widget.data
                    })));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        appBar: AppBar(
            title: const Text("Регистрация компании"), leading: const BackIconButton()),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Страна",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const Divider(height: 8),
              countries.isEmpty
                  ? Shimmer.fromColors(
                      baseColor: const Color(0xffD1D5DB),
                      highlightColor: const Color(0xfff4f5f7),
                      child: Container(
                          height: 48,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: const Color(0xffF9FAFB),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1, color: const Color(0xffE5E5EA)))),
                    )
                  : GestureDetector(
                      onTap: showCountriesModal,
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: const Color(0xffF9FAFB),
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(width: 1, color: const Color(0xffE5E5EA))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: SvgPicture.network(
                                  currentCountry['flag'],
                                  height: 14,
                                )),
                            const Divider(indent: 8),
                            Expanded(
                              child: Text(currentCountry['title'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis)),
                            ),
                            SvgPicture.asset('assets/icons/down.svg')
                          ],
                        ),
                      ),
                    ),
              const Divider(indent: 12),
              EmailTextField(
                  textEditingController: emailEditingController,
                  autofocus: false,
                  onSubmitted: () {}),
              const Divider(indent: 12),
              SizedBox(
                height: 30,
                child: TextButton(
                  onPressed: showLoginPage,
                  child: RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                          children: [
                        const TextSpan(text: "Уже зарегистрированы? "),
                        TextSpan(
                            text: "Авторизуйтесь",
                            style:
                                TextStyle(color: ColorComponent.blue['700'])),
                      ])),
                ),
              ),
              const Divider(indent: 8),
              Button(onPressed: verifyData, title: "Подтвердить"),
              const Divider(indent: 8),
              const PrivacyPolicyWidget()
            ],
          ),
        ),
      ),
    );
  }
}
