import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class NotificationDeniedPage extends StatelessWidget {
  const NotificationDeniedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/miniNotification.svg',
                width: MediaQuery.of(context).size.width / 3,
              ),
              const SizedBox(height: 30),
              const Text(
                "Разрешите уведомления",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Уведомления помогут вам быть в курсе актуальной информации, новых функций и интересных событий в нашем приложении",
                style: TextStyle(fontSize: 15, height: 1.7),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Button(
                  onPressed: () {
                    AppSettings.openAppSettings(type: AppSettingsType.location);
                  },
                  title: "Разрешить доступ",
                  backgroundColor: ColorComponent.mainColor),
              SizedBox(height: MediaQuery.of(context).size.height / 10)
            ],
          ),
        ),
      ),
    );
  }
}
