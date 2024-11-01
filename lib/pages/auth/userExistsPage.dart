import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/emailTextField.dart';
import 'package:gservice5/component/textField/phoneTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/auth/loginPage.dart';
import 'package:gservice5/pages/auth/registration/registrationPage.dart';

class UserExistsPage extends StatefulWidget {
  final bool showBack;
  const UserExistsPage({super.key, required this.showBack});

  @override
  State<UserExistsPage> createState() => _UserExistsPageState();
}

class _UserExistsPageState extends State<UserExistsPage>
    with SingleTickerProviderStateMixin {
  TextEditingController emailEditingController =
      TextEditingController(text: "mukhametzhan.tileubek@gmail.com");
  TextEditingController phoneEditingController =
      TextEditingController(text: "+7 (747) 265-23-38");
  bool byPhone = true;
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      byPhone = tabController.index == 0;
      print(tabController.index);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    emailEditingController.dispose();
    phoneEditingController.dispose();
    super.dispose();
  }

  Future postData() async {
    showModalLoader(context);
    try {
      Map<String, dynamic> param = byPhone
          ? {"phone": getIntComponent(phoneEditingController.text)}
          : {"email": emailEditingController.text};
      Response response = await dio.get("/user-exists", queryParameters: param);
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        showPage(response.data['data']['is_exists']);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void showPage(bool isExists) {
    if (isExists) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(showBackButton: false)));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RegistrationPage()));
    }
  }

  void verifyData() {
    String email = emailEditingController.text.trim();
    String phone = phoneEditingController.text.trim();
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (byPhone) {
      if (emailValid) {
        postData();
      } else {
        SnackBarComponent().showErrorMessage("Неправильный email", context);
      }
    } else {
      if (phone.length == 18) {
        postData();
      } else {
        SnackBarComponent()
            .showErrorMessage("Неправильный номер телефона", context);
      }
    }
  }

  void changedbyPhone(bool value) {
    byPhone = value;
    setState(() {});
    closeKeyboard();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width - 30, 40),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xfff4f4f4)),
                width: MediaQuery.of(context).size.width - 30,
                child: TabBar(
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 0.0,
                  labelColor: Colors.black,
                  labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  unselectedLabelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border(
                      bottom: BorderSide(
                        color: ColorComponent.mainColor,
                        width: 40.0,
                      ),
                    ),
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/phone.svg', width: 16),
                          Divider(indent: 4),
                          Text("По телефону",
                              style: TextStyle(fontWeight: FontWeight.w500))
                        ],
                      ),
                    ),
                    Tab(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/mailBox.svg'),
                        Divider(indent: 4),
                        Text("Через почту",
                            style: TextStyle(fontWeight: FontWeight.w500))
                      ],
                    )),
                  ],
                ),
              )),
        ),
        body: TabBarView(controller: tabController, children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                PhoneTextField(
                    onSubmitted: verifyData,
                    textEditingController: phoneEditingController,
                    autofocus: false)
              ],
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                EmailTextField(
                    textEditingController: emailEditingController,
                    onSubmitted: verifyData)
              ],
            ),
          ),
        ]),
        // byPhone
        //     ? SingleChildScrollView(
        //         padding: EdgeInsets.all(15),
        //         child: Column(
        //           children: [
        //             PhoneTextField(
        //                 onSubmitted: verifyData,
        //                 textEditingController: phoneEditingController,
        //                 autofocus: false)
        //           ],
        //         ),
        //       )
        //     : SingleChildScrollView(
        //         padding: EdgeInsets.all(15),
        //         child: Column(
        //           children: [
        //             EmailTextField(
        //                 textEditingController: emailEditingController,
        //                 onSubmitted: verifyData)
        //           ],
        //         ),
        //       ),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: verifyData,
                padding: EdgeInsets.symmetric(horizontal: 15),
                backgroundColor: ColorComponent.mainColor,
                title: "Продолжить")),
      ),
    );
  }
}
