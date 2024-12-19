import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/auth/accountType/infoTypeAccountModal.dart';
import 'package:gservice5/pages/auth/login/loginBusinessPage.dart';
import 'package:gservice5/pages/auth/login/loginPage.dart';

class ChangedAccountType extends StatefulWidget {
  const ChangedAccountType({super.key});

  @override
  State<ChangedAccountType> createState() => _ChangedAccountTypeState();
}

class _ChangedAccountTypeState extends State<ChangedAccountType>
    with SingleTickerProviderStateMixin {
  List data = [];
  int currentType = 0;
  bool loader = true;
  String role = "";

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    try {
      Response response = await dio.get("/personal-account-type-info");
      if (response.statusCode == 200 && response.data['success']) {
        await getRole();
        List dataRes = response.data['data'];
        for (Map value in dataRes) {
          value['active'] = await getToken("token_${value['type']}");
        }
        print(dataRes);
        data = dataRes;
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void showRegistrationPage() {
    Map currentValue = data[currentType];
    if (currentValue['type'] == "individual") {
      if (currentValue['active']) {
        ChangedToken().changeIndividualToken(context);
      } else {
        showAuthPage(currentValue['type']);
      }
    } else if (currentValue['type'] == "customer") {
      if (currentValue['active']) {
        ChangedToken().changedCustomerToken(context);
      } else {
        showAuthPage(currentValue['type']);
      }
    } else if (currentValue['type'] == "contractor") {
      if (currentValue['active']) {
        ChangedToken().changedContractorToken(context);
      } else {
        showAuthPage(currentValue['type']);
      }
    }
  }

  void showAuthPage(String type) {
    if (type == "individual") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginPage(showBackButton: true)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginBusinessPage(showBackButton: true)));
    }
  }

  Future<bool> getToken(String typeKey) async {
    bool active = await const FlutterSecureStorage().read(key: typeKey) != null;
    return active;
  }

  Future getRole() async {
    role = await ChangedToken().getRole() ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Тип личного кабинета"),
        actions: const [CloseIconButton(iconColor: null, padding: true)],
      ),
      body: loader
          ? const LoaderComponent()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Column(
                children: [
                  Column(
                    children: data.map((value) {
                      int index = data.indexOf(value);
                      bool active = value['active'];
                      if (role == value['type']) return Container();
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
                                            color: ColorComponent.gray['500'])),
                                    const Divider(height: 4),
                                    Text(active ? "Активно" : "Не активно",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: active
                                                ? Colors.green
                                                : ColorComponent.red['500']))
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
