import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class RemoveImageAlert extends StatelessWidget {
  final void Function() removeImage;
  const RemoveImageAlert({super.key, required this.removeImage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Удалить фото"),
            actions: const [CloseIconButton(iconColor: null, padding: true)]),
        body: const Center(
            child: Text("Вы точно хотите удалить фото?",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                textAlign: TextAlign.center)),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                  child: Button(
                      onPressed: () {
                        removeImage();
                        Navigator.pop(context);
                      },
                      backgroundColor: ColorComponent.red['100'],
                      titleColor: ColorComponent.red['600'],
                      title: "Удалить")),
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
