import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/alert/logOutAlert.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/navigation/customer/customerBottomTab.dart';
import 'package:gservice5/pages/ad/my/myAdListPage.dart';
import 'package:gservice5/pages/application/my/myApplicationListPage.dart';
import 'package:gservice5/pages/auth/registration/business/changedActivityBusinessPage.dart';
import 'package:gservice5/pages/profile/aboutCompany/aboutCompanyPage.dart';
import 'package:gservice5/pages/profile/currency/currencyMainPage.dart';
import 'package:gservice5/pages/profile/employees/employeeListPage.dart';
import 'package:gservice5/pages/profile/news/newsMainPage.dart';
import 'package:gservice5/pages/settings/settingsAppPage.dart';
import 'package:gservice5/updateApp/restartAppPage.dart';
import 'package:gservice5/updateApp/updateAppPage.dart';
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
        MaterialPageRoute(builder: (context) => const MyApplicationListPage()));
  }

  void showUpdatePage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const UpdateAppPage()));
  }

  void showMyAdPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyAdListPage()));
  }

  void showContactsPage() {
    Navigator.pushNamed(context, "AddContactsPage");
  }

  void showNewsPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const NewsMainPage()));
  }

  void showSocialNetworkPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const NewsMainPage()));
  }

  void showEditCurrencyPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CurrencyMainPage()));
  }

  void showEmployeesPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const EmployeeListPage()));
  }

  void showAboutCompanyPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AboutCompanyPage()));
  }

  void showChangedActivityBusinessPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ChangedActivityBusinessPage()));
  }

  void showSettingsAppPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SettingsAppPage()));
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
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: ColorComponent.gray['100']!))),
          child: ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const RestartAppPage()));
              },
              leading: SvgPicture.asset('assets/icons/file.svg'),
              title: const Text("Перезапуск приложение"),
              trailing: SvgPicture.asset('assets/icons/right.svg')),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: ColorComponent.gray['100']!))),
          child: ListTile(
              onTap: () => showUpdatePage(),
              leading: SvgPicture.asset('assets/icons/file.svg'),
              title: const Text("Обновить приложение"),
              trailing: SvgPicture.asset('assets/icons/right.svg')),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: ColorComponent.gray['100']!))),
          child: ListTile(
              onTap: () => showMyApplicationPage(),
              leading: SvgPicture.asset('assets/icons/file.svg'),
              title: const Text("Мои заказы"),
              trailing: SvgPicture.asset('assets/icons/right.svg')),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: ColorComponent.gray['100']!))),
          child: ListTile(
              onTap: () => showMyAdPage(),
              leading: SvgPicture.asset('assets/icons/clipboardOutline.svg'),
              title: const Text("Мои объявления"),
              trailing: SvgPicture.asset('assets/icons/right.svg')),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: ColorComponent.gray['100']!))),
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
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: ColorComponent.gray['100']!))),
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
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: ColorComponent.gray['100']!))),
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
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: ColorComponent.gray['100']!))),
                child: ListTile(
                    onTap: () {},
                    leading: SvgPicture.asset('assets/icons/fileOutline.svg'),
                    title: const Text("Документы"),
                    trailing: SvgPicture.asset('assets/icons/right.svg')),
              ),
        role == "customer"
            ? Container()
            : Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: ColorComponent.gray['100']!))),
                child: ListTile(
                    onTap: showEditCurrencyPage,
                    leading: SvgPicture.asset('assets/icons/dollarOutline.svg'),
                    title: const Text("Конвертор валют"),
                    trailing: SvgPicture.asset('assets/icons/right.svg')),
              ),
        role == "customer"
            ? Container()
            : Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: ColorComponent.gray['100']!))),
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
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: ColorComponent.gray['100']!))),
                child: ListTile(
                    onTap: showChangedActivityBusinessPage,
                    leading: SvgPicture.asset('assets/icons/portfolio.svg',
                        color: ColorComponent.mainColor),
                    title: const Text("Вид деятельность"),
                    trailing: SvgPicture.asset('assets/icons/right.svg')),
              ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: ColorComponent.gray['100']!))),
          child: ListTile(
              onTap: () => showSettingsAppPage(),
              leading: SvgPicture.asset('assets/icons/cogOutline.svg'),
              title: const Text("Настройки"),
              trailing: SvgPicture.asset('assets/icons/right.svg')),
        ),
        // Container(
        //   decoration: BoxDecoration(
        //       border:  Border(bottom: BorderSide(width: 1,color: ColorComponent.gray['100']!))),
        //   child: ListTile(
        //       onTap: showAboutCompanyPage,
        //       leading: SvgPicture.asset(
        //         'assets/icons/logoOutline.svg',
        //         color: ColorComponent.mainColor,
        //         width: 20,
        //       ),
        //       title: const Text("О GService"),
        //       trailing: SvgPicture.asset('assets/icons/right.svg')),
        // ),
        // Container(
        //   decoration: BoxDecoration(
        //       border:  Border(bottom: BorderSide(width: 1,color: ColorComponent.gray['100']!))),
        //   child: ListTile(
        //     onTap: () {

        //     },
        //     leading: SvgPicture.asset('assets/icons/exit.svg'),
        //     title: const Text("Выход"),
        //   ),
        // ),
        // Divider(height: 1, color: ColorComponent.gray['100']),
      ],
    );
  }
}
