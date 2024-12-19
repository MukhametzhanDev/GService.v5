import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class AboutCompanyPage extends StatefulWidget {
  const AboutCompanyPage({super.key});

  @override
  State<AboutCompanyPage> createState() => _AboutCompanyPageState();
}

class _AboutCompanyPageState extends State<AboutCompanyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 200,
        leading: BackTitleButton(
          title: "О GService",
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
              child: Column(children: [
            SvgPicture.asset("assets/icons/logo.svg", width: 60),
            const Divider(height: 12),
            const Text("GService",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const Text("мир спецтехники", style: TextStyle(fontSize: 12)),
            const Divider(height: 24),
            Text(
                "Удобный сервис, тысячи потенциальных клиентов по всему Казахстану, качественная аналитика и выгодные условия продвижения ваших товаров и услуг",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 12, color: ColorComponent.gray['500']))
          ])),
        ),
        Divider(height: 1, color: ColorComponent.gray['200']),
        ListTile(
            onTap: () {},
            leading: SvgPicture.asset('assets/icons/fileOutline.svg'),
            title: const Text("Политика конфиденциальности"),
            trailing: SvgPicture.asset('assets/icons/right.svg')),
        Divider(height: 1, color: ColorComponent.gray['200']),
        ListTile(
            leading: SvgPicture.asset('assets/icons/fileOutline.svg'),
            title: const Text("Правила пользования"),
            trailing: SvgPicture.asset('assets/icons/right.svg')),
        Divider(height: 1, color: ColorComponent.gray['200']),
        ListTile(
            leading: SvgPicture.asset('assets/icons/headsetOutline.svg'),
            title: const Text("Служба поддержки"),
            trailing: SvgPicture.asset('assets/icons/right.svg')),
        Divider(height: 1, color: ColorComponent.gray['200']),
        ListTile(
            leading: SvgPicture.asset('assets/icons/phone.svg',
                color: ColorComponent.mainColor),
            title: const Text("Контакты"),
            trailing: SvgPicture.asset('assets/icons/right.svg')),
        Divider(height: 1, color: ColorComponent.gray['200']),
      ])),
    );
  }
}
