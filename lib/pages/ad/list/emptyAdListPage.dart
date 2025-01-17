import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/application/sectionCreateApplicationPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EmptyAdListPage extends StatefulWidget {
  const EmptyAdListPage({super.key});

  @override
  State<EmptyAdListPage> createState() => _EmptyAdListPageState();
}

class _EmptyAdListPageState extends State<EmptyAdListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/icons/clipboardOutline.svg",
              width: 120, color: ColorComponent.gray['500']),
          const Divider(indent: 12),
          const Text("К сожалению, по вашему\nзапросу ничего не найдено",
          textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const Divider(indent: 12),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Вы можете бесплатно разместить заказ, и исполнители свяжутся с вами!",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontSize: 15, height: 1.5),
              )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: () {
                showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) => const SectionCreateApplicationPage());
              },
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Разместить заказ")),
    );
  }
}
