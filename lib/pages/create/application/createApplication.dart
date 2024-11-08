import 'package:flutter/material.dart';
import 'package:gservice5/pages/create/application/createApplicationSectionPage.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';

class CreateApplication extends StatefulWidget {
  const CreateApplication({super.key});

  @override
  State<CreateApplication> createState() => _CreateApplicationState();
}

class _CreateApplicationState extends State<CreateApplication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 140,
          leading: BackTitleButton(onPressed: () {}, title: "Тип заявки"),
          actions: [CloseIconButton(iconColor: null, padding: true)],
        ),
        body: IndexedStack(children: [CreateApplicationSectionPage()]));
  }
}
