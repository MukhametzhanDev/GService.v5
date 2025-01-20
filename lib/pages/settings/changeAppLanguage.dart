import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class ChangeAppLanguage extends StatefulWidget {
  const ChangeAppLanguage({super.key});

  @override
  State<ChangeAppLanguage> createState() => _ChangeAppLanguageState();
}

class _ChangeAppLanguageState extends State<ChangeAppLanguage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text("Язык приложения"),
            centerTitle: false,
            actions: [CloseIconButton(iconColor: null, padding: true)],
          ),
          ListTile(
              onTap: () {},
              title: Text("Қазақша"),
              trailing: SvgPicture.asset("assets/icons/right.svg")),
          Divider(height: 1, color: ColorComponent.gray['100']),
          ListTile(
              onTap: () {},
              title: Text("Русский"),
              trailing: SvgPicture.asset("assets/icons/right.svg")),
          Divider(height: 1, color: ColorComponent.gray['100']),
          ListTile(
              onTap: () {},
              title: Text("English"),
              trailing: SvgPicture.asset("assets/icons/right.svg")),
          Divider(height: 1, color: ColorComponent.gray['100']),
          SizedBox(height: MediaQuery.of(context).padding.bottom)
        ],
      ),
    );
  }
}
