import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/profile/employees/addEmployeePage.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List data = [];
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/employees");
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

  void deleteEmployee(int index) {
    setState(() {
      data.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            leading: const BackTitleButton(title: "Сотрудники"),
            leadingWidth: 200,
            bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 70),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            width: 1, color: Colors.grey.withOpacity(0.3))),
                    margin: const EdgeInsets.only(
                        left: 16, right: 16, top: 8, bottom: 16),
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 12, bottom: 12),
                    child: Row(children: [
                      SvgPicture.asset("assets/icons/searchOutline.svg",
                          color: ColorComponent.gray['500']),
                      const Divider(indent: 8),
                      Text(context.localizations.search,
                          style: TextStyle(color: ColorComponent.gray['500']))
                    ])))),
        body: loader
            ? const LoaderComponent()
            : Column(children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text("Сотрудники",
                                style: TextStyle(
                                    color: ColorComponent.gray['500']))),
                        Text("Действия",
                            style: TextStyle(color: ColorComponent.gray['500']))
                      ]),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          Map employee = data[index];
                          return Container(
                            height: 64,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xfff4f5f7)))),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CacheImage(
                                      url: employee['image'],
                                      width: 40,
                                      height: 40,
                                      borderRadius: 20),
                                  const Divider(indent: 12),
                                  Expanded(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Text(employee['name'],
                                            style: TextStyle(
                                                color:
                                                    ColorComponent.blue['700'],
                                                fontWeight: FontWeight.w500)),
                                        Text(employee['phone'])
                                      ])),
                                  SvgPicture.asset(
                                      "assets/icons/editBadge.svg"),
                                  const Divider(indent: 8),
                                  GestureDetector(
                                    onTap: () => deleteEmployee(index),
                                    child: SvgPicture.asset(
                                        "assets/icons/deleteBadge.svg"),
                                  ),
                                ]),
                          );
                        }))
              ]),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEmployeePage()),
            ).then((newEmployee) {
              if (newEmployee != null) {
                setState(() {
                  data.add(newEmployee);
                });
              }
            });
          },
          backgroundColor: ColorComponent.mainColor,
          titleColor: Colors.black,
          icon: null,
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
          widthIcon: null,
          title: "Добавить сотрудника",
        )));
  }
}
