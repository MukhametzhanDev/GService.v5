import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/auth/registration/business/contractor/registrationContractorPage.dart';
import 'package:gservice5/pages/auth/registration/business/customer/registrationCustomerPage.dart';
import 'package:gservice5/pages/auth/registration/user/userExistsPage.dart';
import 'package:gservice5/pages/auth/registration/user/registrationUserPage.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerificationPhonePage extends StatefulWidget {
  final Map userData;
  const VerificationPhonePage({super.key, required this.userData});

  @override
  State<VerificationPhonePage> createState() => _VerificationPhonePageState();
}

class _VerificationPhonePageState extends State<VerificationPhonePage>
    with CodeAutoFill {
  String otpCode = '';
  bool loader = true;
  TextEditingController codeController = TextEditingController();

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
      Response response = await dio.post("/send-sms-verify-code",
          queryParameters: {
            "phone": getIntComponent(widget.userData['phone'])
          });
      print(response.data);
      if (response.data['success']) {
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  Future verifyCode() async {
    print(codeController.text);
    try {
      showModalLoader(context);
      Response response = await dio.post("/verify-sms-code", queryParameters: {
        "phone": getIntComponent(widget.userData['phone']),
        "code": codeController.text
      });
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        showRegistrationPage();
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void showRegistrationPage() {
    Navigator.pop(context);
    if (widget.userData['role'] == "contractor") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RegistrationContractorPage(data: widget.userData)));
    } else if (widget.userData['role'] == "customer") {
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
                  RegistrationUserPage(data: widget.userData)));
    }
  }

  @override
  void codeUpdated() {
    codeController.text = code!;
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
    cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Код подтверждения'),
        leading: BackIconButton(),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(children: [
            SvgPicture.asset('assets/icons/sendCodePhone.svg'),
            Divider(height: 24),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      style: TextStyle(
                          color: ColorComponent.gray['500'],
                          fontWeight: FontWeight.w500),
                      text:
                          "На ваш номер телефона ${widget.userData['phone']} был выслан SMS-код для подтверждения регистрации"),
                  // TextSpan(
                  //     style: TextStyle(
                  //         color: ColorComponent.blue[''],
                  //         fontWeight: FontWeight.w500),
                  //     text: " Неверный номер?")
                ])),
            Divider(height: 24),
            Pinput(
                length: 4,
                controller: codeController,
                defaultPinTheme: PinTheme(
                  width: 48,
                  height: 56,
                  margin: EdgeInsets.only(left: 10),
                  textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w800),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                ),
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onCompleted: (pin) async {
                  await verifyCode();
                })
          ])),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Column(children: [
        TimerButtonComponent(onPressed: sendCode),
        SizedBox(height: 10),
        Button(
          onPressed: verifyCode,
          title: "Подтвердить",
          padding: EdgeInsets.only(left: 16, right: 16),
          backgroundColor: ColorComponent.mainColor,
        )
      ])),
    );
  }
}

class TimerButtonComponent extends StatefulWidget {
  final onPressed;
  const TimerButtonComponent({super.key, @required this.onPressed});

  @override
  State<TimerButtonComponent> createState() => _TimerButtonComponentState();
}

class _TimerButtonComponentState extends State<TimerButtonComponent> {
  late Timer _timer;
  int _start = 59;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() => timer.cancel());
        } else {
          setState(() => _start--);
        }
      },
    );
  }

  void replaceTimer() {
    widget.onPressed();
    if (_start == 0) {
      setState(() => _start = 59);
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorTheme = ThemeColorComponent.ColorsTheme(context);
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
          onPressed: _start == 0 ? () => replaceTimer() : null,
          style: TextButton.styleFrom(
              backgroundColor: ColorTheme['white_black'],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Запросить код повторно" +
                    (_start > 0
                        ? " (${_start.toString().padLeft(2, '')})"
                        : ""),
                style: TextStyle(color: Colors.black),
              ),
            ],
          )),
    );
  }
}
