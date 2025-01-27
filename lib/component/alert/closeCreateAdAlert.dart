import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class CloseCreateAdAlert extends StatelessWidget {
  const CloseCreateAdAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Закрыть подачу объявления?"),
            actions: const [CloseIconButton(iconColor: null, padding: true)]),
        body: const Center(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "Данные не сохранятся\nи вам придётся начинать всё сначала",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15,height: 1.5),
            textAlign: TextAlign.center,
          ),
        )),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                  child: Button(
                      onPressed: () {
                        CreateData.data.clear();
                        CreateData.characteristic.clear();
                        CreateData.images.clear();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      backgroundColor: ColorComponent.red['100'],
                      titleColor: ColorComponent.red['600'],
                      title: "Закрыть")),
              const Divider(indent: 8),
              Expanded(
                  child: Button(
                      onPressed: () => Navigator.pop(context),
                      title: context.localizations.cancel))
            ],
          ),
        )),
      ),
    );
  }
}
