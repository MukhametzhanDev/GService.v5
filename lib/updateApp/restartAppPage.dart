import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:restart_app/restart_app.dart';

class RestartAppPage extends StatefulWidget {
  const RestartAppPage({super.key});

  @override
  State<RestartAppPage> createState() => _RestartAppPageState();
}

class _RestartAppPageState extends State<RestartAppPage> {
  // void showStore() async {
  //   if (Platform.isIOS) {
  //     await launchUrl(
  //         Uri.parse("https://apps.apple.com/kz/app/gservice/id1627674303"),
  //         mode: LaunchMode.externalApplication);
  //   } else {
  //     await launchUrl(
  //         Uri.parse(
  //             "https://play.google.com/store/apps/details?id=com.gservice&pcampaignid=web_share"),
  //         mode: LaunchMode.externalApplication);
  //   }
  // }

  void restartApp() {
    Restart.restartApp(
      /// In Web Platform, Fill webOrigin only when your new origin is different than the app's origin
      // webOrigin: 'http://example.com',

      // Customizing the restart notification message (only needed on iOS)
      notificationTitle: 'Restarting App',
      notificationBody: 'Please tap here to open the app again.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/icons/restart.svg",
              width: 120, color: ColorComponent.gray['500']),
          const Divider(indent: 12),
          const Text("Правления ошибок и улучшения работы",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const Divider(indent: 12),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Закройте и откройте приложение заново, чтобы устранить сбои и повысить производительность.\nСпасибо! 😊",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontSize: 15, height: 1.5),
              )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: restartApp,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Перезапустить")),
    );
  }
}
