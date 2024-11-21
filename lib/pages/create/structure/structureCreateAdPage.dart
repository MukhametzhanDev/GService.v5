import 'package:flutter/material.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/options/getSelectPage.dart';

class StructureCreateAdPage extends StatefulWidget {
  final Map data;
  const StructureCreateAdPage({super.key, required this.data});

  @override
  State<StructureCreateAdPage> createState() => _StructureCreateAdPageState();
}

class _StructureCreateAdPageState extends State<StructureCreateAdPage> {
  PageController pageController = PageController();
  List<Widget> pages = [];
  bool loader = true;

  @override
  void initState() {
    super.initState();
    formattedPages();
  }

  void formattedPages() {
    savedCategoryId();
    List options = widget.data['options'];
    for (Map value in options) {
      pages.add(GetSelectPage(
          title: "",
          value: value,
          param: {},
          showOptionsPage: () {},
          options: widget.data['options'],
          pageController: pageController));
    }
    loader = false;
    setState(() {});
  }

  void savedCategoryId() {
    CreateData.data['category_id'] = widget.data['id'];
  }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loader
            ? LoaderComponent()
            : PageView(
                controller: pageController,
                children: pages,
                physics: NeverScrollableScrollPhysics())
        // ValueListenableBuilder(
        //     valueListenable: controller.pageIndexNotifier,
        //     builder: (context, pageIndex, child) {
        //       return IndexedStack(index: pageIndex, children: pages);
        //     }),
        );
  }
}
