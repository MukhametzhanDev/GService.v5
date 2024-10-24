import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final void Function() onSubmitted;
  const PasswordTextField(
      {super.key,
      required this.textEditingController,
      required this.onSubmitted});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool showPassword = false;
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
        style: TextStyle(fontSize: 14, height: 1.1),
        decoration: InputDecoration(
            hintText: "Пароль",
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
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
