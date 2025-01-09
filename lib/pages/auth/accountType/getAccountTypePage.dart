import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/auth/accountType/infoTypeAccountModal.dart';
import 'package:gservice5/pages/auth/registration/business/businessExistsPage.dart';
import 'package:gservice5/pages/auth/registration/customer/customerExistsPage.dart';

class GetAccountTypePage extends StatefulWidget {
  const GetAccountTypePage({super.key});

  @override
  State<GetAccountTypePage> createState() => _GetAccountTypePageState();
}

class _GetAccountTypePageState extends State<GetAccountTypePage>
    with SingleTickerProviderStateMixin {
  List data = [];
  int currentType = 0;
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    try {
      Response response = await dio.get("/personal-account-type-info");
      if (response.statusCode == 200 && response.data['success']) {
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

  void showRegistrationPage() {
    if (data[currentType]['type'] == "customer") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CustomerExistsPage(
                  // data: {"role": data[currentType]['type']}
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BusinessExistsPage(
                  data: {"role": data[currentType]['type']})));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackIconButton(),
          title: const Text("Тип личного кабинета")),
      body: loader
          ? const LoaderComponent()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Column(
                children: [
                  Column(
                    children: data.map((value) {
                      int index = data.indexOf(value);
                      return GestureDetector(
                        onTap: () {
                          currentType = index;
                          setState(() {});
                          // showInfoTypeAccount(value);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  width: 1,
                                  color: index == currentType
                                      ? ColorComponent.mainColor
                                      : const Color(0xffEEEEEE))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: currentType == index ? 4 : 1,
                                          color: index == currentType
                                              ? const Color(0xff1A56DB)
                                              : const Color(0xffD1D5DB)))),
                              const Divider(indent: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(value['title'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16)),
                                    const Divider(height: 4),
                                    Text(value['sub_title'],
                                        style: TextStyle(
                                            color: ColorComponent.gray['500']))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const Divider(),
                  InfoTypeAccountModal(data: data[currentType]['description'])
                ],
              )),
      bottomNavigationBar: loader
          ? null
          : BottomNavigationBarComponent(
              child: Button(
                  onPressed: showRegistrationPage,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  title: "Продолжить")),
    );
  }
}
