import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/alert/logOutAlert.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/wallet/showWalletWidget.dart';
import 'package:gservice5/pages/profile/customer/changeCustomerProfilePage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:readmore/readmore.dart';

class ContractorProfilePage extends StatefulWidget {
  const ContractorProfilePage({super.key});

  @override
  State<ContractorProfilePage> createState() => _ContractorProfilePageState();
}

class _ContractorProfilePageState extends State<ContractorProfilePage> {
  Map data = {};
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    try {
      Response response = await dio.get("/company");
      print(response.data);
      if (response.data['success'] && response.statusCode == 200) {
        data = response.data['data'];
        loader = false;
        setState(() {});
      } else if (response.statusCode == 401) {
        ChangedToken().removeToken(context);
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
                builder: (context) => ChangeCustomerProfilePage(data: data)))
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: loader
            ? AppBar()
            : AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data['name']),
                    Divider(indent: 4),
                    SvgPicture.asset('assets/icons/badgeСheck.svg')
                  ],
                ),
              ),
        body: loader
            ? LoaderComponent()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Color(0xffE5E7EB)),
                                    borderRadius: BorderRadius.circular(41)),
                                child: CacheImage(
                                    url: data['avatar'],
                                    width: 80,
                                    height: 80,
                                    borderRadius: 40),
                              ),
                              Divider(indent: 16),
                              Expanded(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text("${numberFormat(150)}K",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17)),
                                      Text(
                                        "подписчики",
                                        style: TextStyle(
                                            color: ColorComponent.gray['500']),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text("Стратовый",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17)),
                                      Text("Тариф",
                                          style: TextStyle(
                                              color:
                                                  ColorComponent.gray['500']))
                                    ],
                                  ),
                                ],
                              ))
                            ],
                          ),
                          // Divider(height: 12),
                          // Text(data['name'],
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.w500, fontSize: 16)),
                          Divider(height: 8),
                          ReadMoreText(
                            data['description'] ??
                                "Вниманию всех потенциальных клиентов и заинтересованных лиц в Республике Казахстан: ТОО ZOOMLION Central Asia является исключительным правообладателем товарного знака ZOOMLION на территории Республики",
                            trimMode: TrimMode.Line,
                            trimLines: 3,
                            trimCollapsedText: 'еще',
                            trimExpandedText: '',
                            moreStyle: TextStyle(
                                fontSize: 14,
                                color: ColorComponent.gray['500'],
                                fontWeight: FontWeight.w500),
                          ),
                          Divider(height: 12),
                          Row(children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: showChangeCustomerProfilePage,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: ColorComponent.mainColor),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    "Изменить",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Divider(indent: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: ColorComponent.mainColor),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    "Поделиться",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          Divider(height: 10),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: ColorComponent.gray['100']),
                    ShowWalletWidget(),
                    ListTile(
                        leading: SvgPicture.asset('assets/icons/file.svg'),
                        title: Text("Мои заявки"),
                        trailing: SvgPicture.asset('assets/icons/right.svg')),
                    Divider(height: 1, color: ColorComponent.gray['100']),
                    ListTile(
                        leading: SvgPicture.asset(
                            'assets/icons/clipboardOutline.svg'),
                        title: Text("Мои Объявления"),
                        trailing: SvgPicture.asset('assets/icons/right.svg')),
                    Divider(height: 1, color: ColorComponent.gray['100']),
                    ListTile(
                        leading: SvgPicture.asset('assets/icons/logistic.svg'),
                        title: Text("Логистика"),
                        trailing: SvgPicture.asset('assets/icons/right.svg')),
                    Divider(height: 1, color: ColorComponent.gray['100']),
                    ListTile(
                        leading: SvgPicture.asset('assets/icons/bullhorn.svg'),
                        title: Text("Новости"),
                        trailing: SvgPicture.asset('assets/icons/right.svg')),
                    Divider(height: 1, color: ColorComponent.gray['100']),
                    ListTile(
                        leading:
                            SvgPicture.asset('assets/icons/cogOutline.svg'),
                        title: Text("Настройки"),
                        trailing: SvgPicture.asset('assets/icons/right.svg')),
                    Divider(height: 1, color: ColorComponent.gray['100']),
                    ListTile(
                      onTap: () {
                        showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context) =>
                                LogOutAlert(onPressed: () async {
                                  await ChangedToken().removeToken(context);
                                }));
                      },
                      leading: SvgPicture.asset('assets/icons/exit.svg'),
                      title: Text("Выход"),
                    ),
                    Divider(height: 1, color: ColorComponent.gray['100']),
                  ],
                ),
              ),

        //  loader
        //     ? LoaderComponent()
        //     : SingleChildScrollView(
        //         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Row(
        //               children: [
        //                 Container(
        //                   decoration: BoxDecoration(
        //                       border:
        //                           Border.all(width: 1, color: Color(0xffE5E7EB)),
        //                       borderRadius: BorderRadius.circular(41)),
        //                   child: CacheImage(
        //                       url: data['avatar'],
        //                       width: 80,
        //                       height: 80,
        //                       borderRadius: 40),
        //                 ),
        //                 Divider(indent: 16),
        //                 Expanded(
        //                     child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                   children: [
        //                     Column(
        //                       children: [
        //                         Text(numberFormat(150),
        //                             style: TextStyle(
        //                                 fontWeight: FontWeight.w500,
        //                                 fontSize: 17)),
        //                         Text("подписчики")
        //                       ],
        //                     ),
        //                     Column(
        //                       children: [
        //                         Text(numberFormat(40),
        //                             style: TextStyle(
        //                                 fontWeight: FontWeight.w500,
        //                                 fontSize: 17)),
        //                         Text("объявлении")
        //                       ],
        //                     ),
        //                     Column(
        //                       children: [
        //                         Text(numberFormat(19),
        //                             style: TextStyle(
        //                                 fontWeight: FontWeight.w500,
        //                                 fontSize: 17)),
        //                         Text("заявки")
        //                       ],
        //                     ),
        //                   ],
        //                 ))
        //               ],
        //             ),
        //             Divider(indent: 16),
        //             Text(data['name'],
        //                 style:
        //                     TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        //             Divider(height: 8),
        //             ReadMoreText(
        //               data['description'] ??
        //                   "Вниманию всех потенциальных клиентов и заинтересованных лиц в Республике Казахстан: ТОО ZOOMLION Central Asia является исключительным правообладателем товарного знака ZOOMLION на территории Республики",
        //               trimMode: TrimMode.Line,
        //               trimLines: 3,
        //               trimCollapsedText: 'еще',
        //               trimExpandedText: '',
        //               moreStyle:
        //                   TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        //             ),
        //             Divider(height: 12),
        //             Row(children: [
        //               Expanded(
        //                 child: GestureDetector(
        //                   onTap: () {},
        //                   child: Container(
        //                     alignment: Alignment.center,
        //                     padding:
        //                         EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        //                     decoration: BoxDecoration(
        //                         color: ColorComponent.gray['200'],
        //                         borderRadius: BorderRadius.circular(4)),
        //                     child: Text(
        //                       "Изменить",
        //                       style: TextStyle(fontWeight: FontWeight.w500),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //               Divider(indent: 8),
        //               Expanded(
        //                 child: GestureDetector(
        //                   onTap: () {},
        //                   child: Container(
        //                     alignment: Alignment.center,
        //                     padding:
        //                         EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        //                     decoration: BoxDecoration(
        //                         color: ColorComponent.gray['200'],
        //                         borderRadius: BorderRadius.circular(4)),
        //                     child: Text(
        //                       "Поделиться",
        //                       style: TextStyle(fontWeight: FontWeight.w500),
        //                     ),
        //                   ),
        //                 ),
        //               )
        //             ]),

        //           ],
        //         ),
        //       ),
      ),
    );
  }
}
