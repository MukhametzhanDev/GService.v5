import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/alert/logOutAlert.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/data/message/messageInviteApp.dart';
import 'package:gservice5/navigation/routes/app_router.gr.dart';
import 'package:gservice5/pages/settings/aboutAppPage.dart';
import 'package:gservice5/pages/settings/changeAppLanguage.dart';
import 'package:gservice5/pages/settings/supportSeviceModal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SettingsAppPage extends StatefulWidget {
  const SettingsAppPage({super.key});

  @override
  State<SettingsAppPage> createState() => _SettingsAppPageState();
}

class _SettingsAppPageState extends State<SettingsAppPage> {
  void showChangedLanguage() {
    showModalBottomSheet(
        context: context, builder: (context) => const ChangeAppLanguage());
  }

  void showHelpdescModal() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const HelpdeskModal()));
  }

  void showAboutApp() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AboutApplicationPage()));
  }

  void sendInvite() async {
    await MessageInviteApp().sendUserInvite();
  }

  void exitAccount() async {
    await ChangedToken().removeToken(context);
    if (mounted) {
      context.router.pushAndPopUntil(const CustomerBottomRoute(),
          predicate: (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackTitleButton(title: "Настройки"),
          leadingWidth: 200),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ListTile(
              onTap: showChangedLanguage,
              title: const Text("Язык приложения"),
              trailing: SvgPicture.asset("assets/icons/right.svg")),
          Divider(height: 1, color: ColorComponent.gray['100']),
          ListTile(
              onTap: showHelpdescModal,
              title: const Text("Служба поддержки"),
              trailing: SvgPicture.asset("assets/icons/right.svg")),
          Divider(height: 1, color: ColorComponent.gray['100']),
          ListTile(
              onTap: sendInvite,
              title: const Text("Пригласить друзей"),
              trailing: SvgPicture.asset("assets/icons/right.svg")),
          Divider(height: 1, color: ColorComponent.gray['100']),
          ListTile(
              onTap: showAboutApp,
              title: const Text("О приложении"),
              trailing: SvgPicture.asset("assets/icons/right.svg")),
          Divider(height: 1, color: ColorComponent.gray['100']),
          ListTile(
              onTap: () {
                showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => LogOutAlert(onPressed: exitAccount));
              },
              title: Text("Выйти из профиля",
                  style: TextStyle(color: ColorComponent.red['500']))),
          Divider(height: 1, color: ColorComponent.gray['100'])
        ],
      )),
    );
  }
}
