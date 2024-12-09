import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/alert/logOutAlert.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/my/myAdListPage.dart';
import 'package:gservice5/pages/application/my/myApplicationListPage.dart';
import 'package:gservice5/pages/profile/aboutCompany/aboutCompanyPage.dart';
import 'package:gservice5/pages/profile/currency/editCurrencyPage.dart';
import 'package:gservice5/pages/profile/employees/employeeListPage.dart';
import 'package:gservice5/pages/profile/news/newsMainPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProfileListTilesWidget extends StatefulWidget {
  const ProfileListTilesWidget({super.key});

  @override
  State<ProfileListTilesWidget> createState() => _ProfileListTilesWidgetState();
}

class _ProfileListTilesWidgetState extends State<ProfileListTilesWidget> {
  String role = "";

  @override
  void initState() {
    getRole();
    super.initState();
  }

  Future getRole() async {
    role = await ChangedToken().getRole();
    setState(() {});
  }

  void showMyApplicationPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyApplicationListPage()));
  }

  void showMyAdPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyAdListPage()));
  }

  void showNewsPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewsMainPage()));
  }

  void showEditCurrencyPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditCurrencyPage()));
  }

  void showEmployeesPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EmployeeListPage()));
  }

  void showAboutCompanyPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AboutCompanyPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Color(0xfff4f5f7))),
          child: ListTile(
              onTap: () => showMyApplicationPage(),
              leading: SvgPicture.asset('assets/icons/file.svg'),
              title: Text("Мои заявки"),
              trailing: SvgPicture.asset('assets/icons/right.svg')),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Color(0xfff4f5f7))),
          child: ListTile(
              onTap: () => showMyAdPage(),
              leading: SvgPicture.asset('assets/icons/clipboardOutline.svg'),
              title: Text("Мои объявления"),
              trailing: SvgPicture.asset('assets/icons/right.svg')),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Color(0xfff4f5f7))),
          child: ListTile(
              leading: SvgPicture.asset('assets/icons/logistic.svg'),
              title: Text("Логистика"),
              trailing: SvgPicture.asset('assets/icons/right.svg')),
        ),
        role == "individual"
            ? Container()
            : Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Color(0xfff4f5f7))),
                child: ListTile(
                    onTap: showNewsPage,
                    leading: SvgPicture.asset('assets/icons/bullhorn.svg'),
                    title: Text("Новости"),
                    trailing: SvgPicture.asset('assets/icons/right.svg')),
              ),
        role == "individual"
            ? Container()
            : Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Color(0xfff4f5f7))),
                child: ListTile(
                    leading: SvgPicture.asset('assets/icons/fileOutline.svg'),
                    title: Text("Документы"),
                    trailing: SvgPicture.asset('assets/icons/right.svg')),
              ),
        role == "individual"
            ? Container()
            : Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Color(0xfff4f5f7))),
                child: ListTile(
                    onTap: showEditCurrencyPage,
                    leading: SvgPicture.asset('assets/icons/dollarOutline.svg'),
                    title: Text("Моя валюта"),
                    trailing: SvgPicture.asset('assets/icons/right.svg')),
              ),
        role == "individual"
            ? Container()
            : Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Color(0xfff4f5f7))),
                child: ListTile(
                    onTap: showEmployeesPage,
                    leading: SvgPicture.asset('assets/icons/users.svg'),
                    title: Text("Сотрудники"),
                    trailing: SvgPicture.asset('assets/icons/right.svg')),
              ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Color(0xfff4f5f7))),
          child: ListTile(
              leading: SvgPicture.asset('assets/icons/cogOutline.svg'),
              title: Text("Настройки"),
              trailing: SvgPicture.asset('assets/icons/right.svg')),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Color(0xfff4f5f7))),
          child: ListTile(
              onTap: showAboutCompanyPage,
              leading: SvgPicture.asset(
                'assets/icons/logoOutline.svg',
                color: ColorComponent.mainColor,
                width: 20,
              ),
              title: Text("О GService"),
              trailing: SvgPicture.asset('assets/icons/right.svg')),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Color(0xfff4f5f7))),
          child: ListTile(
            onTap: () {
              showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => LogOutAlert(onPressed: () async {
                        await ChangedToken().removeToken(context);
                      }));
            },
            leading: SvgPicture.asset('assets/icons/exit.svg'),
            title: Text("Выход"),
          ),
        ),
        Divider(height: 1, color: ColorComponent.gray['100']),
      ],
    );
  }
}
