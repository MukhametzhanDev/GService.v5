import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
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
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.4,
                fontSize: 13),
            children: [
          const TextSpan(text: "Продолжая регистрацию вы соглашаетесь с "),
          TextSpan(
            text: "правилами пользования",
            style: TextStyle(
                color: ColorComponent.blue['700'],
                decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                GetIt.I<FirebaseAnalytics>().logEvent(
                    name: GAEventName.buttonClick,
                    parameters: {
                      'button_name': GAParams.textButtonAgreement
                    }).catchError((e) => debugPrint(e));
                print('object');
              },
          ),
          const TextSpan(text: " и "),
          TextSpan(
            text: "политикой конфиденциальности",
            style: TextStyle(
              color: ColorComponent.blue['700'],
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                GetIt.I<FirebaseAnalytics>().logEvent(
                    name: GAEventName.buttonClick,
                    parameters: {
                      'button_name': GAParams.textButtonPolicy
                    }).catchError((e) => debugPrint(e));
                print('object');
              },
          ),
        ]));
  }
}
