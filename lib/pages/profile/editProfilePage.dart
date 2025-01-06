import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/pages/profile/changePasswordPage.dart';
import 'package:gservice5/pages/profile/business/changeBusinessProfilePage.dart';
import 'package:gservice5/pages/profile/customer/changeCusomterProfilePage.dart';

class EditProfilePage extends StatefulWidget {
  final Map data;
  const EditProfilePage({super.key, required this.data});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String role = "";

  @override
  void initState() {
    getRole();
    super.initState();
  }

  void getRole() async {
    String roleValue = await ChangedToken().getRole();
    role = roleValue;
    setState(() {});
  }

  void editProfileDetails() {
    if (role == "individual") {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChangeCustomerProfilePage(data: widget.data)))
          .then((value) => backSendData(value));
    } else if (role == "customer") {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChangeCustomerProfilePage(data: widget.data)))
          .then((value) => backSendData(value));
    } else if (role == "contractor") {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChangeBusinessProfilePage(data: widget.data)))
          .then((value) => backSendData(value));
    }
  }

  void backSendData(value) {
    if (value != null) {
      Navigator.pop(context, value);
    }
  }

  void editPasswordPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ChangePasswordPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 400,
        leading: BackTitleButton(
            title: "Редактировать профиль",
            onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 1, color: Color(0xffeeeeee)))),
                child: ListTile(
                    onTap: () => editProfileDetails(),
                    title: const Text("Изменить данные профиля"),
                    trailing: SvgPicture.asset('assets/icons/right.svg'))),
            Container(
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 1, color: Color(0xffeeeeee)))),
                child: ListTile(
                    onTap: () => editPasswordPage(),
                    title: const Text("Изменить пароль"),
                    trailing: SvgPicture.asset('assets/icons/right.svg'))),
            role == "individual"
                ? Container()
                : Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                width: 1, color: Color(0xffeeeeee)))),
                    child: ListTile(
                        title: const Text("Редактировать контакты"),
                        trailing: SvgPicture.asset('assets/icons/right.svg'))),
            // Container(
            //     decoration: BoxDecoration(
            //         border: Border(
            //             top: BorderSide(width: 1, color: Color(0xffeeeeee)))),
            //     child: ListTile(
            //         title: Text("Сменить данные для входа"),
            //         trailing: SvgPicture.asset('assets/icons/right.svg'))),
          ],
        ),
      ),
    );
  }
}
