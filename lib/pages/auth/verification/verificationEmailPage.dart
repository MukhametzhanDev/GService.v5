import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/timerButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/auth/registration/business/contractor/registrationContractorPage.dart';
import 'package:gservice5/pages/auth/registration/business/customer/registrationCustomerPage.dart';
import 'package:gservice5/pages/auth/registration/individual/registrationUserPage.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:url_launcher/url_launcher.dart';

class VerificationEmailPage extends StatefulWidget {
  final String email;
  final Map<String, dynamic> userData;
  const VerificationEmailPage(
      {super.key, required this.email, required this.userData});

  @override
  State<VerificationEmailPage> createState() => _VerificationEmailPageState();
}

class _VerificationEmailPageState extends State<VerificationEmailPage>
    with CodeAutoFill {
  String otpCode = '';
  bool loader = true;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listenForCode();
    sendCode();
  }

  void sendCode() async {
    try {
      loader = true;
      setState(() {});
      Response response = await dio.post("/send-mail-verify-code",
          queryParameters: {"email": widget.email});
      print(response.data);
      if (response.statusCode == 200 && response.data['success']) {
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void verifyCode() async {
    showModalLoader(context);
    print('otpCode $otpCode');
    try {
      Response response = await dio.post("/verify-mail-code", data: {
        "email": widget.email,
        "code": textEditingController.text,
        "for_password_reset": false
      });
      Navigator.pop(context);
      if (response.statusCode == 200 && response.data['success']) {
        showRegistrationPage();
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code!;
    });
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    cancel();
  }

  void showRegistrationPage() {
    Navigator.pop(context);
    if (widget.userData['role'] == "contractor") {
      widget.userData['email'] = widget.email;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RegistrationContractorPage(data: widget.userData)));
    } else if (widget.userData['role'] == "customer") {
      widget.userData['email'] = widget.email;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RegistrationCustomerPage(data: widget.userData)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RegistrationIndividualPage(data: widget.userData)));
    }
  }

  Future<void> openEmailApp() async {
    final Uri emailUri = Uri(scheme: 'mailto:email');
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      print('object');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(leading: const BackIconButton(), title: const Text('Код подтверждения')),
      body: loader
          ? const LoaderComponent()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                SvgPicture.asset('assets/icons/verificationEmail.svg'),
                const Divider(height: 24),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: TextStyle(
                            height: 1.6,
                            color: ColorComponent.gray['500'],
                            fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                              text:
                                  "Код на подтверждение была отправлена вам на почту ${widget.email}\n"),
                          TextSpan(
                            text: "Проверить почту",
                            style: TextStyle(color: ColorComponent.blue['500']),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => openEmailApp(),
                          )
                        ])),
                const Divider(height: 16),
                Text(
                    "Письмо обычно доходит до 15 минут, так же рекомендуем проверить вкладку “Спам”",
                    style: TextStyle(
                        height: 1.6,
                        color: ColorComponent.gray['500'],
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center),
                const Divider(height: 24),
                Pinput(
                    length: 4,
                    controller: textEditingController,
                    autofocus: true,
                    defaultPinTheme: PinTheme(
                      width: 48,
                      height: 56,
                      margin: const EdgeInsets.only(left: 10),
                      textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w800),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) {
                      verifyCode();
                    })
              ])),
      bottomNavigationBar: loader
          ? null
          : BottomNavigationBarComponent(
              child: Column(children: [
              TimerButton(onPressed: sendCode),
              const SizedBox(height: 10),
              Button(
                onPressed: verifyCode,
                title: "Подтвердить регистрацию",
                padding: const EdgeInsets.only(left: 16, right: 16),
                backgroundColor: ColorComponent.mainColor,
              )
            ])),
    );
  }
}
