import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/auth/login/loginPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EmptyTokenPage extends StatefulWidget {
  const EmptyTokenPage({super.key});

  @override
  State<EmptyTokenPage> createState() => _EmptyTokenPageState();
}

class _EmptyTokenPageState extends State<EmptyTokenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/icons/user.svg", width: 120),
          Divider(indent: 12),
          Text("Войдите или создайте учетную запись",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Divider(indent: 12),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Для выполнения этой функции, просим вас пройти регистрацию",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontSize: 15, height: 1.5),
              )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(showBackButton: true)));
              },
              padding: EdgeInsets.symmetric(horizontal: 15),
              title: "Авторизация")),
    );
  }
}
