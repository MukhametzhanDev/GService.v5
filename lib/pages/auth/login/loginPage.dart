import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/auth/login/loginBusinessPage.dart';
import 'package:gservice5/pages/auth/login/loginUserPage.dart';

class LoginPage extends StatefulWidget {
  final bool showBackButton;
  const LoginPage({super.key, required this.showBackButton});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: GestureDetector(
            onTap: () => closeKeyboard(),
            child: Scaffold(
                appBar: AppBar(
                  title: const Text("Войти в GService"),
                  leading: widget.showBackButton
                      ? const BackIconButton()
                      : Container(),
                  bottom: PreferredSize(
                      preferredSize:
                          Size(MediaQuery.of(context).size.width, 44),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xffeeeeee)),
                        width: MediaQuery.of(context).size.width - 30,
                        height: 44,
                        child: TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: Colors.black,
                          indicatorPadding: const EdgeInsets.all(3),
                          tabs: const [Tab(text: "Физ лицо"), Tab(text: "Юр лицо")],
                          indicator: BoxDecoration(
                            color: ColorComponent.mainColor,
                            borderRadius: BorderRadius.circular(6),
                            border: Border(
                              bottom: BorderSide(
                                  color: ColorComponent.mainColor, width: 6.0),
                            ),
                          ),
                        ),
                      )),
                ),
                body: const TabBarView(children: [
                  LoginUserPage(),
                  LoginBusinessPage(showBackButton: false)
                ]))));
  }
}
