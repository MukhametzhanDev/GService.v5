import 'package:flutter/material.dart';
import 'package:gservice5/pages/create/options/getTypeEquipmentPage2.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';

class StructureCreateAdPage extends StatefulWidget {
  final Map data;
  const StructureCreateAdPage({super.key, required this.data});

  @override
  State<StructureCreateAdPage> createState() => _StructureCreateAdPageState();
}

class _StructureCreateAdPageState extends State<StructureCreateAdPage> {
  final PageControllerIndexedStack controller = PageControllerIndexedStack();

  @override
  void initState() {
    super.initState();
  }

  void formattedPages() {}

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: controller.pageIndexNotifier,
          builder: (context, pageIndex, child) {
            return IndexedStack(
                index: pageIndex,
                children: [GetTypeEquipmentPage2(multiple: false)]);
          }),
    );
  }
}
