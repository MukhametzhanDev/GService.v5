import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/charactestic/getChildCharacteristicPage.dart';
import 'package:gservice5/pages/settings/deleteAccountModal.dart';
import 'package:gservice5/pages/settings/supportSeviceModal.dart';
import 'package:gservice5/pages/webView/webViewPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutApplicationPage extends StatefulWidget {
  const AboutApplicationPage({super.key});

  @override
  State<AboutApplicationPage> createState() => _AboutApplicationPageState();
}

class _AboutApplicationPageState extends State<AboutApplicationPage> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future getDataAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  Future getDataPhone() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return "${capitalized(androidInfo.brand)} ${androidInfo.model}, ${androidInfo.version.release}";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return "${iosInfo.name}, iOS ${iosInfo.systemVersion}";
    } else {
      return "";
    }
  }

  void showHelpdeskModalPage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackTitleButton(title: "О приложении"),
        leadingWidth: 200,
      ),
      body: FutureBuilder(
          future: getDataAppVersion(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderComponent();
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SvgPicture.asset('assets/icons/iconApp.svg',
                            width: 70)),
                    const SizedBox(height: 20),
                    Text(
                        "Версия ${snapshot.data.version} (${snapshot.data.buildNumber})"),
                    const SizedBox(height: 10),
                    FutureBuilder(
                        future: getDataPhone(),
                        builder: (context, phoneData) {
                          if (phoneData.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          } else {
                            return Text(phoneData.data);
                          }
                        }),
                    const SizedBox(height: 20),
                    Divider(height: 1, color: ColorComponent.gray['100']),
                    const SizedBox(height: 20),
                    Button(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HelpdeskModal()));
                        },
                        title: "Написать службу поддержки"),
                    const SizedBox(height: 20),
                    const Text(
                        "Мы работаем в будние дни с 9:00 до 20:00 и в праздничные/выходные дни с 9:00 до 17:00",
                        textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    Divider(height: 1, color: ColorComponent.gray['100']),
                    ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WebViewPage(
                                      url:
                                          "https://business.gservice.kz/termsofuse")));
                        },
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Пользовательское соглашение"),
                        trailing: SvgPicture.asset('assets/icons/right.svg')),
                    Divider(height: 1, color: ColorComponent.gray['100']),
                    ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WebViewPage(
                                      url:
                                          "https://business.gservice.kz/termsofuse")));
                        },
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Политика конфедициальности"),
                        trailing: SvgPicture.asset('assets/icons/right.svg')),
                    Divider(height: 1, color: ColorComponent.gray['100']),
                    // ListTile(
                    //     onTap: () {
                    //       // showModalBottomSheet(
                    //       //     context: context,
                    //       //     isScrollControlled: true,
                    //       //     shape: const RoundedRectangleBorder(
                    //       //       borderRadius: BorderRadius.vertical(
                    //       //           top: Radius.circular(10.0)),
                    //       //     ),
                    //       //     builder: (context) {
                    //       //       return RateAppPage();
                    //       //     });
                    //     },
                    //     contentPadding: EdgeInsets.zero,
                    //     title: Text("Оценить приложение"),
                    //     trailing: SvgPicture.asset('assets/icons/right.svg')),
                    // Divider(height: 1, color: ColorComponent.gray['100']),
                    ListTile(
                        onTap: () {
                          showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => const DeleteAccountModal());
                        },
                        contentPadding: EdgeInsets.zero,
                        title: Text("Удалить аккаунт",
                            style: TextStyle(color: ColorComponent.red2))),
                    Divider(height: 1, color: ColorComponent.gray['100']),
                  ],
                ),
              );
            }
          }),
    );
  }
}
