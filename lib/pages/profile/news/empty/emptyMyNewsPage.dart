import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:url_launcher/url_launcher.dart';

class EmptyMyNewsPage extends StatefulWidget {
  const EmptyMyNewsPage({super.key});

  @override
  State<EmptyMyNewsPage> createState() => _EmptyMyNewsPageState();
}

class _EmptyMyNewsPageState extends State<EmptyMyNewsPage> {
  void showSite() async {
    await launchUrl(Uri.parse('https://gservice.kz'),
        mode: LaunchMode.inAppBrowserView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/icons/bullhorn.svg",
            width: 120, color: ColorComponent.gray['500']),
        const Divider(indent: 12),
        const Text("У вас пока нет новостей",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const Divider(indent: 12),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "На данный момент у вас нет добавленных новостей. Вы можете создать новость, используя веб-версию.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 15, height: 1.5),
            )),
        Button(
            onPressed: showSite,
            padding: const EdgeInsets.all(15),
            title: "Перейти на сайт")
      ],
    ));
  }
}
