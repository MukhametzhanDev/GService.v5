import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class EmptyMyNewsPage extends StatefulWidget {
  const EmptyMyNewsPage({super.key});

  @override
  State<EmptyMyNewsPage> createState() => _EmptyMyNewsPageState();
}

class _EmptyMyNewsPageState extends State<EmptyMyNewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/icons/bullhorn.svg",
            width: 120, color: ColorComponent.gray['500']),
        Divider(indent: 12),
        Text("У вас пока нет новостей",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        Divider(indent: 12),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "На данный момент у вас нет добавленных новостей. Вы можете создать новость, используя веб-версию.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 15, height: 1.5),
            )),
      ],
    ));
  }
}
