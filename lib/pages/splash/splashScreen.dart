import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/navigation/%D1%81ustomer/customerBottomTab.dart';
import 'package:gservice5/navigation/contractor/contractorBottomTab.dart';
import 'package:gservice5/navigation/individual/individualBottomTab.dart';
import 'package:gservice5/component/dio/dio.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    String? token = await ChangedToken().getToken();
    String? role = await ChangedToken().getRole();
    print(token);
    print(role);
    if (token != null) {
      dio.options.headers['authorization'] = "Bearer $token";
    }
    if (role == "customer" || role == "contractor") {
      dio.options.baseUrl = "https://dev.gservice-co.kz/api/business/";
    }
    await showPage(role);
  }

  Future showPage(String? role) async {
    if (role == "customer") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => CustomerBottomTab()),
          (route) => false);
    } else if (role == "contractor") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => ContractorBottomTab()),
          (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => IndividualBottomTab()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFF9500),
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/logoOutline.svg',
                    width: 100, height: 100),
              ],
            ),
            Positioned(
                bottom: 100,
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 3))),
          ],
        ),
      ),
    );
  }
}
