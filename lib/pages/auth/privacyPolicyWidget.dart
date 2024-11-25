import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class PrivacyPolicyWidget extends StatefulWidget {
  const PrivacyPolicyWidget({super.key});

  @override
  State<PrivacyPolicyWidget> createState() => _PrivacyPolicyWidgetState();
}

class _PrivacyPolicyWidgetState extends State<PrivacyPolicyWidget> {
  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.4,
                fontSize: 13),
            children: [
          TextSpan(text: "Продолжая регистрацию вы соглашаетесь с "),
          TextSpan(
            text: "правилами пользования",
            style: TextStyle(
                color: ColorComponent.blue['700'],
                decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                print('object');
              },
          ),
          TextSpan(text: " и "),
          TextSpan(
            text: "политикой конфиденциальности",
            style: TextStyle(
              color: ColorComponent.blue['700'],
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                print('object');
              },
          ),
        ]));
  }
}
