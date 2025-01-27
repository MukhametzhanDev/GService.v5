import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/request/getMainPageData.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/navigation/routes/app_router.gr.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  final String? path;
  const SplashScreen({super.key, @PathParam() this.path});

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
    await getMainData(role);
  }

  Future getMainData(String? role) async {
    await GetMainPageData().getData(context);
    await showPage(role);
    // showDeepLink();
  }

  Future showPage(String? role) async {
    if (role == "business") {
      print('object');
      context.router.pushAndPopUntil(const BusinessBottomRoute(),
          predicate: (route) => false);
    } else {
      print('123');
      context.router.pushAndPopUntil(const CustomerBottomRoute(),
          predicate: (route) => false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFF9500),
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
            const Positioned(
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
