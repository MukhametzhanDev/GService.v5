import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';

class LogOutAlert extends StatelessWidget {
  final void Function() onPressed;
  const LogOutAlert({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Выйти из профиля"),
            actions: [CloseIconButton(iconColor: null, padding: true)]),
        body: Center(
            child: Text(
          "Вы точно хотите выйти из аккаунта?",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        )),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                  child: Button(
                      onPressed: () {
                        Navigator.pop(context);
                        onPressed();
                      },
                      backgroundColor: ColorComponent.red['100'],
                      titleColor: ColorComponent.red['600'],
                      title: "Выйти")),
              Divider(indent: 8),
              Expanded(
                  child: Button(
                      onPressed: () => Navigator.pop(context), title: "Отмена"))
            ],
          ),
        )),
      ),
    );
  }
}
