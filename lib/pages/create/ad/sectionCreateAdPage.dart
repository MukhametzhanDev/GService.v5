import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/auth/emptyTokenPage.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/structure/structureCreateAdPage.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class SectionCreateAdPage extends StatefulWidget {
  const SectionCreateAdPage({super.key});

  @override
  State<SectionCreateAdPage> createState() => _SectionCreateAdPageState();
}

class _SectionCreateAdPageState extends State<SectionCreateAdPage> {
  int currentIndex = 0;
  List data = [];
  bool loader = true;
  bool verifyToken = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    clearData();
    super.dispose();
  }

  void clearData() {
    CreateData.data.clear();
    CreateData.characteristic.clear();
    CreateData.images.clear();
  }

  Future getData() async {
    verifyToken = await ChangedToken().getToken() != null;
    if (verifyToken) {
      try {
        Response response = await dio.get("/ad-categories");
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
    } else {
      loader = false;
    }
    setState(() {});
  }

  void changedCurrentSection(index) {
    currentIndex = index;
    setState(() {});
  }

  void showPage() {
    CreateData.data['category_id'] = data[currentIndex]['id'];
    CreateData.data['category'] = data[currentIndex];
    CreateData.characteristic['characteristics'] =
        data[currentIndex]['options']['characteristics'];
    showOptionsPage();
  }

  void showOptionsPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                StructureCreateAdPage(data: data[currentIndex])));
    // Navigator.pop(context);
  }

  Map getParam(index) {
    List options = data[currentIndex]['options']['necessary_inputs'];
    if (index == 0 || index == options.length - 1) {
      return {};
    } else {
      String key = options[index - 1]?['name'] ?? "";
      Map param = {key: CreateData.data[key] ?? ""};
      return param;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width - 100,
          leading: CloseTitleButton(
              onPressed: () => Navigator.pop(context),
              title: context.localizations.select_the_type_of_advertisement)),
      body: loader
          ? const LoaderComponent()
          : !verifyToken
              ? const EmptyTokenPage()
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Укажите о чем будет ваще объявление"),
                        const Divider(height: 16),
                        Column(
                            children: data.map((value) {
                          int index = data.indexOf(value);
                          bool active = currentIndex == index;
                          return GestureDetector(
                            onTap: () {
                              changedCurrentSection(index);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 1,
                                      color: active
                                          ? ColorComponent.mainColor
                                          : const Color(0xffeeeeee))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              width: active ? 4 : 1,
                                              color: active
                                                  ? const Color(0xff1A56DB)
                                                  : const Color(0xffD1D5DB)))),
                                  const Divider(indent: 12),
                                  Expanded(
                                    child: Text(value['title'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  const Divider(indent: 12),
                                  SvgPicture.network(value['icon'], width: 24)
                                ],
                              ),
                            ),
                          );
                        }).toList()),
                      ]),
                ),
      bottomSheet: loader
          ? const SizedBox.shrink()
          : !verifyToken
              ? const SizedBox.shrink()
              : BottomNavigationBarComponent(
                  child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                  child: Button(
                      onPressed: showPage,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      title: "Продолжить"),
                )),
    );
  }
}
