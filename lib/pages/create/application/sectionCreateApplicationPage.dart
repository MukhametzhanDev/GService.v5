import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/back/closeTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/application/createApplication2.dart';
import 'package:gservice5/pages/create/data/createData.dart';

class SectionCreateApplicationPage extends StatefulWidget {
  const SectionCreateApplicationPage({super.key});

  @override
  State<SectionCreateApplicationPage> createState() =>
      _SectionCreateApplicationPageState();
}

class _SectionCreateApplicationPageState
    extends State<SectionCreateApplicationPage> {
  int currentIndex = 0;
  List data = [];
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    CreateData.data.clear();
    super.dispose();
  }

  void getData() async {
    try {
      Response response = await dio.get("/application-categories");
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

  void changedCurrentSection(index) {
    currentIndex = index;
    setState(() {});
  }

  void showPage() {
    CreateData.data['category_id'] = data[currentIndex]['id'];
    // CreateData.data['category'] = data[currentIndex];
    // Navigator.pushNamed(context, "CreateApplication");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CreateApplication2(data: data[currentIndex])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width - 100,
          leading: CloseTitleButton(
              onPressed: () => Navigator.pop(context),
              title: "Разместить заказ")),
      body: loader
          ? const LoaderComponent()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Какая у вас задача?",
                        style: TextStyle(fontSize: 15)),
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
                                      borderRadius: BorderRadius.circular(8),
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
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: showPage,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Продолжить")),
    );
  }
}
