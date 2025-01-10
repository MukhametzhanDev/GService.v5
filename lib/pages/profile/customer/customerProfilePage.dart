import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/navigation/customer/customerBottomTab.dart';
import 'package:gservice5/pages/payment/wallet/showWalletWidget.dart';
import 'package:gservice5/pages/profile/editProfilePage.dart';
import 'package:gservice5/pages/profile/profileListTilesWidget.dart';
import 'package:gservice5/pages/profile/wallet/replenishment/replenishmentWalletPage.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  Map data = {};
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    try {
      Response response = await dio.get("/user");
      print(response.data);
      if (response.data['success'] && response.statusCode == 200) {
        data = response.data['data'];
        loader = false;
        setState(() {});
      } else if (response.statusCode == 401) {
        await ChangedToken().removeToken(context);
        if (mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const CustomerBottomTab()),
              (route) => false);
        }
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void showChangeCustomerProfilePage() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditProfilePage(data: data)))
        .then((value) => changedDataUser(value));
  }

  void changedDataUser(Map? value) {
    if (value != null) {
      data = value;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text("Профиль")),
      body: loader
          ? const LoaderComponent()
          : SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => showChangeCustomerProfilePage(),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: Color(0xffeeeeee)))),
                      child: Row(
                        children: [
                          CacheImage(
                              url: data['avatar'],
                              width: 48,
                              height: 48,
                              borderRadius: 24),
                          const Divider(indent: 12),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['name'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              Text("ID: ${data['id']}",
                                  style: TextStyle(
                                      color: ColorComponent.gray['500']))
                            ],
                          )),
                          SvgPicture.asset('assets/icons/right.svg',
                              color: Colors.black)
                        ],
                      ),
                    ),
                  ),
                  const ShowWalletWidget(showButton: true),
                  const ProfileListTilesWidget()
                ],
              ),
            ),
    );
  }
}
