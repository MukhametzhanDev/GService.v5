import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/application/sectionCreateApplicationPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EmptyMyApplicationPage extends StatefulWidget {
  const EmptyMyApplicationPage({super.key});

  @override
  State<EmptyMyApplicationPage> createState() => _EmptyMyApplicationPageState();
}

class _EmptyMyApplicationPageState extends State<EmptyMyApplicationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/file.svg",
            width: 120,
            color: ColorComponent.gray['500'],
          ),
          const Divider(indent: 12),
          const Text("Здесь будет ваши заявки",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const Divider(indent: 12),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Оставляйте заявки, чтобы быстро и удобно найти подходящую спецтехнику.",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontSize: 15, height: 1.5),
              )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: () {
                showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => const SectionCreateApplicationPage());
              },
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Создать")),
    );
  }
}
