import 'package:flutter/material.dart';
import 'package:gservice5/component/button/backIconButton.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/auth/registration/registrationNonResidentWidget.dart';
import 'package:gservice5/pages/auth/registration/registrationResidentKzWidget.dart';

class RegistrationPage extends StatefulWidget {
  final String email;
  final String phone;
  final bool byPhone;
  const RegistrationPage(
      {super.key,
      required this.email,
      required this.phone,
      required this.byPhone});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.byPhone ? 0 : 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onTap: () => closeKeyboard(),
        child: Scaffold(
            appBar: AppBar(
              title: Text("Регистрация"),
              leading: const BackIconButton(),
              bottom: PreferredSize(
                  preferredSize:
                      Size(MediaQuery.of(context).size.width - 30, 40),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xfff4f4f4)),
                    width: MediaQuery.of(context).size.width - 30,
                    child: TabBar(
                      controller: tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 0.0,
                      labelColor: Colors.black,
                      labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      unselectedLabelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          bottom: BorderSide(
                            color: ColorComponent.mainColor,
                            width: 40.0,
                          ),
                        ),
                      ),
                      tabs: [
                        Tab(text: 'Резидент Казахстана'),
                        Tab(text: 'Нерезидент Казахстана'),
                      ],
                    ),
                  )),
            ),
            body: TabBarView(controller: tabController, children: [
              RegistrationResidentKzWidget(phone: widget.phone),
              RegistrationNonResidentWidget(email: widget.email)
            ])),
      ),
    );
  }
}
