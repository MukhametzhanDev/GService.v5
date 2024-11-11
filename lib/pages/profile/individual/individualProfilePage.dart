import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/wallet/showWalletWidget.dart';
import 'package:gservice5/pages/application/my/myApplicationListPage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class IndividualProfilePage extends StatefulWidget {
  const IndividualProfilePage({super.key});

  @override
  State<IndividualProfilePage> createState() => _IndividualProfilePageState();
}

class _IndividualProfilePageState extends State<IndividualProfilePage> {
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
        ChangedToken().removeIndividualToken(context);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void logOut() async {
    try {
      showModalLoader(context);
      Response response = await dio.post("/logout");
      Navigator.pop(context);
      print(response.data);
      ChangedToken().removeIndividualToken(context);
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Text("Профиль")),
      body: loader
          ? LoaderComponent()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    decoration: BoxDecoration(
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
                        Divider(indent: 12),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['name'],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
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
                  ShowWalletWidget(),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyApplicationListPage(
                                  showAppBar: true,
                                  refreshController: RefreshController())));
                    },
                    leading: SvgPicture.asset('assets/icons/fileOutline.svg'),
                    title: Text("Мои заявки"),
                    trailing: SvgPicture.asset('assets/icons/right.svg'),
                  ),
                  Divider(height: 1, color: ColorComponent.gray['100']),
                  ListTile(
                    leading:
                        SvgPicture.asset('assets/icons/clipboardOutline.svg'),
                    title: Text("Мои Объявления"),
                    trailing: SvgPicture.asset('assets/icons/right.svg'),
                  ),
                  Divider(height: 1, color: ColorComponent.gray['100']),
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/logistic.svg'),
                    title: Text("Логистика"),
                    trailing: SvgPicture.asset('assets/icons/right.svg'),
                  ),
                  Divider(height: 1, color: ColorComponent.gray['100']),
                  ListTile(
                    leading:
                        SvgPicture.asset('assets/icons/bullhornOutline.svg'),
                    title: Text("Новости"),
                    trailing: SvgPicture.asset('assets/icons/right.svg'),
                  ),
                  Divider(height: 1, color: ColorComponent.gray['100']),
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/cogOutline.svg'),
                    title: Text("Настройки"),
                    trailing: SvgPicture.asset('assets/icons/right.svg'),
                  ),
                  Divider(height: 1, color: ColorComponent.gray['100']),
                  ListTile(
                    onTap: logOut,
                    leading: SvgPicture.asset('assets/icons/exit.svg'),
                    title: Text("Выход"),
                  ),
                  Divider(height: 1, color: ColorComponent.gray['100']),
                ],
              ),
            ),
    );
  }
}
