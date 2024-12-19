import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/pages/ad/my/edit/editAdCharacteristics.dart';
import 'package:gservice5/pages/ad/my/edit/selectsEditAdPage.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';

class StructureEditAdPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const StructureEditAdPage({super.key, required this.data});

  @override
  State<StructureEditAdPage> createState() => _StructureEditAdPageState();
}

class _StructureEditAdPageState extends State<StructureEditAdPage> {
  Map data = {};
  bool loader = true;
  PageControllerIndexedStack pageControllerIndexedStack =
      PageControllerIndexedStack();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    pageControllerIndexedStack.dispose();
    super.dispose();
  }

  Future getData() async {
    try {
      int id = widget.data['id'];
      print(id);
      Response response = await dio.get('/ad/$id');
      if (response.data['success']) {
        data = response.data['data'];
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void previousPage() {
    int index = pageControllerIndexedStack.getIndex();
    if (index == 0) {
      Navigator.pop(context);
    } else {
      pageControllerIndexedStack.previousPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 200,
          leading: BackTitleButton(
              title: "Редактирование", onPressed: () => previousPage()),
        ),
        body: loader
            ? const LoaderComponent()
            : ValueListenableBuilder<int>(
                valueListenable: pageControllerIndexedStack.pageIndexNotifier,
                builder: (context, pageIndex, child) {
                  return IndexedStack(index: pageIndex, children: [
                    SelectsEditAdPage(data: data),
                  ]);
                }));
  }
}
