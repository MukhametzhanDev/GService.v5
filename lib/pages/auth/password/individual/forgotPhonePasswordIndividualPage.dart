import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/timerButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/auth/password/individual/resetIndividualPasswordPage.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';

class ForgotPhonePasswordIndividualPage extends StatefulWidget {
  final String phone;
  const ForgotPhonePasswordIndividualPage({super.key, required this.phone});

  @override
  State<ForgotPhonePasswordIndividualPage> createState() =>
      _ForgotPhonePasswordIndividualPageState();
}

class _ForgotPhonePasswordIndividualPageState
    extends State<ForgotPhonePasswordIndividualPage> with CodeAutoFill {
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
      Response response = await dio
          .post("/send-sms-verify-code", data: {"phone": widget.phone});
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

  Future verifyCode() async {
    print(codeController.text);
    try {
      showModalLoader(context);
      Response response = await dio.post("/verify-sms-code", data: {
        "phone": widget.phone,
        "code": codeController.text,
        "for_password_reset": true
      });
      print(response.data);
      Navigator.pop(context);
      if (response.statusCode == 200 && response.data['success']) {
        await ChangedToken()
            .savedToken(response.data['data'], context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ResetIndividualPasswordPage()));
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
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
        title: const Text('Код подтверждения'),
        leading: const BackIconButton(),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            SvgPicture.asset('assets/icons/sendCodePhone.svg'),
            const Divider(height: 24),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      style: TextStyle(
                          color: ColorComponent.gray['500'],
                          fontWeight: FontWeight.w500),
                      text:
                          "На ваш номер телефона +${widget.phone} был выслан SMS-код для подтверждения регистрации"),
                ])),
            const Divider(height: 24),
            Pinput(
                length: 4,
                controller: codeController,
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
                onCompleted: (pin) async {
                  await verifyCode();
                })
          ])),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Column(children: [
        TimerButton(onPressed: sendCode),
        const SizedBox(height: 10),
        Button(
          onPressed: verifyCode,
          title: "Подтвердить",
          padding: const EdgeInsets.only(left: 16, right: 16),
          backgroundColor: ColorComponent.mainColor,
        )
      ])),
    );
  }
}
