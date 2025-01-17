import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final void Function() onSubmitted;
  final String? hintText;
  const PasswordTextField(
      {super.key,
      @required this.hintText,
      required this.textEditingController,
      required this.onSubmitted});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool showPassword = false;

  final analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        keyboardType: TextInputType.visiblePassword,
        controller: widget.textEditingController,
        onSubmitted: (value) {
          widget.onSubmitted();
        },
        obscureText: !showPassword,
        style: const TextStyle(fontSize: 14, height: 1.1),
        decoration: InputDecoration(
            hintText: widget.hintText ?? "Пароль",
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });

                  analytics
                      .logEvent(name: GAEventName.buttonClick, parameters: {
                    GAKey.buttonName: GAParams.icBtnShowPwd,
                  }).catchError((e) {
                    if (kDebugMode) {
                      debugPrint(e);
                    }
                  });
                },
                iconSize: 20,
                icon: SvgPicture.asset('assets/icons/eyeOutline.svg',
                    width: 20,
                    color: showPassword ? ColorComponent.mainColor : null))),
      ),
    );
  }
}
