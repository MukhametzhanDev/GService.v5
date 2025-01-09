import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/alert/logOutAlert.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/navigation/customer/customerBottomTab.dart';
import 'package:gservice5/pages/application/my/myApplicationListPage.dart';
import 'package:gservice5/pages/auth/registration/business/changedActivityBusinessPage.dart';
import 'package:gservice5/pages/profile/aboutCompany/aboutCompanyPage.dart';
import 'package:gservice5/pages/profile/currency/currencyMainPage.dart';
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

  final analytics = GetIt.I<FirebaseAnalytics>();

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
        MaterialPageRoute(builder: (context) => const MyApplicationListPage()));
    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.rowBtnProfileMyApplication
    }).catchError((onError) => debugPrint(onError));
  }

  void showMyAdPage() {
    Navigator.pushNamed(context, "MyAdListPage");
    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.rowBtnProfileMyAd
    }).catchError((onError) => debugPrint(onError));
  }

  void showContactsPage() {
    Navigator.pushNamed(context, "AddContactsPage");
    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.rowBtnProfileContacts
    }).catchError((onError) => debugPrint(onError));
  }

  void showNewsPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const NewsMainPage()));
    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.rowBtnProfileNews
    }).catchError((onError) => debugPrint(onError));
  }

  void showSocialNetworkPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const NewsMainPage()));
    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.rowBtnProfileNews
    }).catchError((onError) => debugPrint(onError));
  }

  void showEditCurrencyPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CurrencyMainPage()));
    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.rowBtnProfileEditCurrency
    }).catchError((onError) => debugPrint(onError));
  }

  void showEmployeesPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const EmployeeListPage()));
    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.rowBtnProfileEmployee
    }).catchError((onError) => debugPrint(onError));
  }

  void showAboutCompanyPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AboutCompanyPage()));
    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.rowBtnProfileAbout
    }).catchError((onError) => debugPrint(onError));
  }

  void showChangedActivityBusinessPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ChangedActivityBusinessPage()));
  }

  void exitAccount() async {
    await ChangedToken().removeToken(context);
    if (mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const CustomerBottomTab()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: const Color(0xfff4f5f7))),
          child: ListTile(
              onTap: () => showMyApplicationPage(),
              leading: SvgPicture.asset('assets/icons/file.svg'),
              title: const Text("Мои заказы"),
              trailing: SvgPicture.asset('assets/icons/right.svg')),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: const Color(0xfff4f5f7))),
          child: ListTile(
              onTap: () => showMyAdPage(),
              leading: SvgPicture.asset('assets/icons/clipboardOutline.svg'),
              title: const Text("Мои объявления"),
              trailing: SvgPicture.asset('assets/icons/right.svg')),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: const Color(0xfff4f5f7))),
          child: ListTile(
              onTap: () => showContactsPage(),
              leading: SvgPicture.asset('assets/icons/phoneOutline.svg',
                  color: ColorComponent.mainColor),
              title: const Text("Контакты"),
              trailing: SvgPicture.asset('assets/icons/right.svg')),
        ),
        // Container(
        //     decoration: BoxDecoration(
        //         border: Border.all(width: 1, color: Color(0xfff4f5f7))),
        //     child: ListTile(
        //         leading: SvgPicture.asset('assets/icons/logistic.svg'),
        //         title: Text("Логистика"),
        //         trailing: SvgPicture.asset('assets/icons/right.svg'))),
        role == "customer"
            ? Container()
            : Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: const Color(0xfff4f5f7))),
                child: ListTile(
                    onTap: showNewsPage,
                    leading: SvgPicture.asset('assets/icons/world.svg',
                        color: ColorComponent.mainColor),
                    title: const Text("Социальные сети"),
                    trailing: SvgPicture.asset('assets/icons/right.svg')),
              ),
        role == "customer"
            ? Container()
            : Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: const Color(0xfff4f5f7))),
                child: ListTile(
                    onTap: showNewsPage,
                    leading: SvgPicture.asset('assets/icons/bullhorn.svg'),
                    title: const Text("Новости"),
                    trailing: SvgPicture.asset('assets/icons/right.svg')),
              ),
        role == "customer"
            ? Container()
            : Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: const Color(0xfff4f5f7))),
                child: ListTile(
                    leading: SvgPicture.asset('assets/icons/fileOutline.svg'),
                    title: const Text("Документы"),
                    trailing: SvgPicture.asset('assets/icons/right.svg')),
              ),
        role == "customer"
            ? Container()
            : Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: const Color(0xfff4f5f7))),
                child: ListTile(
                    onTap: showEditCurrencyPage,
                    leading: SvgPicture.asset('assets/icons/dollarOutline.svg'),
                    title: const Text("Моя валюта"),
                    trailing: SvgPicture.asset('assets/icons/right.svg')),
              ),
        role == "customer"
            ? Container()
            : Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: const Color(0xfff4f5f7))),
                child: ListTile(
                    onTap: showEmployeesPage,
                    leading: SvgPicture.asset('assets/icons/users.svg'),
                    title: const Text("Сотрудники"),
                    trailing: SvgPicture.asset('assets/icons/right.svg')),
              ),
        role == "customer"
            ? Container()
            : Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: const Color(0xfff4f5f7))),
                child: ListTile(
                    onTap: showChangedActivityBusinessPage,
                    leading: SvgPicture.asset('assets/icons/cogOutline.svg'),
                    title: const Text("Вид деятельность"),
                    trailing: SvgPicture.asset('assets/icons/right.svg')),
              ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: const Color(0xfff4f5f7))),
          child: ListTile(
              leading: SvgPicture.asset('assets/icons/cogOutline.svg'),
              title: const Text("Настройки"),
              trailing: SvgPicture.asset('assets/icons/right.svg')),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: const Color(0xfff4f5f7))),
          child: ListTile(
              onTap: showAboutCompanyPage,
              leading: SvgPicture.asset(
                'assets/icons/logoOutline.svg',
                color: ColorComponent.mainColor,
                width: 20,
              ),
              title: const Text("О GService"),
              trailing: SvgPicture.asset('assets/icons/right.svg')),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: const Color(0xfff4f5f7))),
          child: ListTile(
            onTap: () {
              showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => LogOutAlert(onPressed: exitAccount));

              analytics.logEvent(name: GAEventName.buttonClick, parameters: {
                GAKey.buttonName: GAParams.rowBtnProfileExit
              }).catchError((onError) => debugPrint(onError));
            },
            leading: SvgPicture.asset('assets/icons/exit.svg'),
            title: const Text("Выход"),
          ),
        ),
        Divider(height: 1, color: ColorComponent.gray['100']),
      ],
    );
  }
}
