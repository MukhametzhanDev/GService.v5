import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/gen/assets.gen.dart';
import 'package:gservice5/l10n/l10n.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';
import 'package:gservice5/localization/streams/general_stream.dart';

class ChangeAppLanguage extends StatefulWidget {
  const ChangeAppLanguage({super.key});

  @override
  State<ChangeAppLanguage> createState() => _ChangeAppLanguageState();
}

class _ChangeAppLanguageState extends State<ChangeAppLanguage> {
  List languagesData = [
    {"title": "Қазақша", "code": "kk"},
    {"title": "Русский", "code": "ru"},
    {"title": "English", "code": "en"},
  ];
  void changeLanguage(String localeCode) {
    GeneralStreams.langaugeStream.add(L10n.locals
        .firstWhere((element) => element.languageCode == localeCode));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Язык приложения"),
            centerTitle: false,
            actions: const [CloseIconButton(iconColor: null, padding: true)],
          ),
          Column(
              children: languagesData.map((value) {
            return Column(children: [
              ListTile(
                  onTap: () => changeLanguage(value['code']),
                  title: Text(value['title']),
                  trailing: context.localizations.localeName == value['code']
                      ? SvgPicture.asset(Assets.icons.checkMini,
                          color: ColorComponent.blue['500'])
                      : SvgPicture.asset(Assets.icons.right)),
              Divider(height: 1, color: ColorComponent.gray['100']),
            ]);
          }).toList()),

          // ListTile(
          //     onTap: () => changeLanguage("ru"),
          //     title: const Text("Русский"),
          //     trailing: SvgPicture.asset("assets/icons/right.svg")),
          // Divider(height: 1, color: ColorComponent.gray['100']),
          // ListTile(
          //     onTap: () => changeLanguage("en"),
          //     title: const Text("English"),
          //     trailing: SvgPicture.asset("assets/icons/right.svg")),
          // Divider(height: 1, color: ColorComponent.gray['100']),
          SizedBox(height: MediaQuery.of(context).padding.bottom)
        ],
      ),
    );
  }
}
