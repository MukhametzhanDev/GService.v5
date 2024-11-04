import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerificationPhonePage extends StatefulWidget {
  const VerificationPhonePage({super.key});

  @override
  State<VerificationPhonePage> createState() => _VerificationPhonePageState();
}

class _VerificationPhonePageState extends State<VerificationPhonePage> with CodeAutoFill {
  String otpCode = '';

  @override
  void initState() {
    super.initState();
    listenForCode();
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
    cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, title: Text('Код подтверждения')),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(children: [
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      style: TextStyle(
                          color: ColorComponent.gray['500'],
                          fontWeight: FontWeight.w500),
                      text:
                          "Мы отправили вам код для подтверждения на почту введите его в поле ниже."),
                  // TextSpan(
                  //     style: TextStyle(
                  //         color: ColorComponent.blue[''],
                  //         fontWeight: FontWeight.w500),
                  //     text: " Неверный номер?")
                ])),
            SizedBox(height: 16),
            Text("Введите код ниже",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            SizedBox(height: 10),
            Pinput(
                length: 6,
                controller: TextEditingController(text: otpCode),
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
                onCompleted: (pin) => print(pin))
          ])),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Column(children: [
        TimerButtonComponent(onPressed: () {}),
        SizedBox(height: 10),
        Button(
          onPressed: () {},
          title: "Подтвердить",
          padding: EdgeInsets.only(left: 16, right: 16),
          backgroundColor: ColorComponent.mainColor,
          titleColor: Colors.white,
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
                        ? " (${_start.toString().padLeft(2, '0')})"
                        : ""),
                style: TextStyle(fontSize: 17, color: Colors.black),
              ),
            ],
          )),
    );
  }
}
