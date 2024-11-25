import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';

class CloseCreateAdAlert extends StatelessWidget {
  const CloseCreateAdAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Закрыть подачу объявления?"),
            actions: [CloseIconButton(iconColor: null, padding: true)]),
        body: Center(
            child: Text(
          "Данные не сохранятся и вам придётся начинать всё сначала",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
          textAlign: TextAlign.center,
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
              Divider(indent: 8),
              Expanded(
                  child: Button(
                      onPressed: () => Navigator.pop(context), title: "Отмена"))
            ],
          ),
        )),
      ),
    );
  }
}
