import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/switchRole/switchRoleWidget.dart';

class MainApplicationsBusinessPage extends StatefulWidget {
  final ScrollController scrollController;
  const MainApplicationsBusinessPage(
      {super.key, required this.scrollController});

  @override
  State<MainApplicationsBusinessPage> createState() =>
      _MainApplicationsBusinessPageState();
}

class _MainApplicationsBusinessPageState
    extends State<MainApplicationsBusinessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("GService Business"),
        actions: [
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset("assets/icons/message.svg",
                  color: Colors.black))
        ],
      ),
      body: Column(children: [
        SwitchRoleWidget()
      ],),
    );
  }
}
