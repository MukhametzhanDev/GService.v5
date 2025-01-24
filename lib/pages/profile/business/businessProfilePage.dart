import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/shareButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/switchRole/changeRoleBusinessModal.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:auto_route/auto_route.dart';
import 'package:gservice5/navigation/routes/app_router.gr.dart';
import 'package:gservice5/pages/payment/wallet/showWalletWidget.dart';
import 'package:gservice5/pages/profile/business/changeBusinessProfilePage.dart';
import 'package:gservice5/pages/profile/profileListTilesWidget.dart';
import 'package:gservice5/provider/nameCompanyProvider.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class BusinessProfilePage extends StatefulWidget {
  const BusinessProfilePage({super.key});

  @override
  State<BusinessProfilePage> createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {
  Map data = {};
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    try {
      Response response = await dio.get("/my-company");
      print(response.data);
      if (response.data['success'] && response.statusCode == 200) {
        data = response.data['data'];
        Provider.of<NameCompanyProvider>(context, listen: false).changedName =
            data['name'].toString();
        Provider.of<NameCompanyProvider>(context, listen: false)
            .changedHasDealer = true;
        loader = false;
        setState(() {});
      } else if (response.statusCode == 401) {
        await ChangedToken().removeToken(context);
        if (mounted) {
          context.router.pushAndPopUntil(const CustomerBottomRoute(),
              predicate: (route) => false);
        }
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void showChangeBusinessProfilePage() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeBusinessProfilePage(data: data)))
        .then((value) => changedDataUser(value));
  }

  void changedDataUser(Map? value) {
    if (value != null) {
      data = value;
      setState(() {});
    }
  }

  void showSwitchAccountModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) => const ChangeRoleBusinessModal());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: loader
            ? AppBar()
            : AppBar(
                centerTitle: false,
                title: GestureDetector(
                  onTap: showSwitchAccountModal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Профиль"),
                      const Divider(indent: 4),
                      SvgPicture.asset('assets/icons/down.svg',
                          color: Colors.black, width: 18)
                    ],
                  ),
                ),
                actions: [
                  GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 32,
                        width: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: ColorComponent.mainColor.withOpacity(.2)),
                        child: SvgPicture.asset('assets/icons/share.svg'),
                      )),
                  Divider(indent: 15)
                ],
              ),
        body: loader
            ? const LoaderComponent()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: showChangeBusinessProfilePage,
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: const Color(0xffE5E7EB)),
                                      borderRadius: BorderRadius.circular(41)),
                                  child: CacheImage(
                                      url: data['avatar'],
                                      width: 80,
                                      height: 80,
                                      borderRadius: 40),
                                ),
                                const Divider(indent: 16),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(data['name'],
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600)),
                                        const Divider(indent: 4),
                                        SvgPicture.asset(
                                            'assets/icons/badgeСheck.svg')
                                      ],
                                    ),
                                    Divider(height: 6),
                                    Text(
                                      "ИИН/БИН: ${data['identifier']}",
                                      style: TextStyle(
                                          color: ColorComponent.gray['500']),
                                    )
                                  ],
                                )),
                                Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: SvgPicture.asset(
                                        "assets/icons/right.svg"))
                                // Expanded(
                                //     child: Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceAround,
                                //   children: [
                                //     Column(
                                //       children: [
                                //         Text("${numberFormat(150)}K",
                                //             style: const TextStyle(
                                //                 fontWeight: FontWeight.w500,
                                //                 fontSize: 17)),
                                //         Text(
                                //           "подписчики",
                                //           style: TextStyle(
                                //               color: ColorComponent.gray['500']),
                                //         )
                                //       ],
                                //     ),
                                //     Column(
                                //       children: [
                                //         const Text("Стратовый",
                                //             style: TextStyle(
                                //                 fontWeight: FontWeight.w500,
                                //                 fontSize: 17)),
                                //         Text("Тариф",
                                //             style: TextStyle(
                                //                 color:
                                //                     ColorComponent.gray['500']))
                                //       ],
                                //     ),
                                //   ],
                                // ))
                              ],
                            ),
                          ),
                          // Divider(height: 12),
                          // Text(data['name'],
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.w500, fontSize: 16)),
                          const Divider(height: 16),
                          data['description'] == "" ||
                                  data['description'] == null
                              ? GestureDetector(
                                  onTap: () => showChangeBusinessProfilePage(),
                                  child: Container(
                                      height: 32,
                                      margin: const EdgeInsets.only(bottom: 8),
                                      alignment: Alignment.centerLeft,
                                      child: Text("Написать описание компании",
                                          style: TextStyle(
                                              color:
                                                  ColorComponent.blue['700']))),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ReadMoreText(
                                    data['description'] ?? "",
                                    trimMode: TrimMode.Line,
                                    trimLines: 3,
                                    trimCollapsedText: 'еще',
                                    trimExpandedText: '',
                                    moreStyle: TextStyle(
                                        fontSize: 14,
                                        color: ColorComponent.gray['500'],
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),

                          // Row(children: [
                          //   Expanded(
                          //     child: GestureDetector(
                          //       onTap: showChangeBusinessProfilePage,
                          //       child: Container(
                          //         alignment: Alignment.center,
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 10, vertical: 6),
                          //         decoration: BoxDecoration(
                          //             border: Border.all(
                          //                 width: 1,
                          //                 color: ColorComponent.mainColor),
                          //             borderRadius: BorderRadius.circular(8)),
                          //         child: const Text("Редактировать",
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.w500)),
                          //       ),
                          //     ),
                          //   ),
                          //   const Divider(indent: 8),
                          //   Expanded(
                          //     child: GestureDetector(
                          //       onTap: () {},
                          //       child: Container(
                          //         alignment: Alignment.center,
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 10, vertical: 6),
                          //         decoration: BoxDecoration(
                          //             border: Border.all(
                          //                 width: 1,
                          //                 color: ColorComponent.mainColor),
                          //             borderRadius: BorderRadius.circular(8)),
                          //         child: const Text(
                          //           "Поделиться",
                          //           style:
                          //               TextStyle(fontWeight: FontWeight.w500),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ]),
                          // const Divider(height: 10),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: ColorComponent.gray['100']),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                              width: 32,
                              height: 32,
                              margin: EdgeInsets.only(right: 15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      ColorComponent.mainColor.withOpacity(.2)),
                              child: SvgPicture.asset(
                                  "assets/icons/starOutline.svg",
                                  width: 28)),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Стартовый пакет",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                              Divider(height: 2),
                              Text(
                                "Ваш тариф",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: ColorComponent.gray['500']),
                              )
                            ],
                          )),
                          SvgPicture.asset("assets/icons/right.svg"),
                          Divider(indent: 8)
                        ],
                      ),
                    ),
                    Divider(height: 1, color: ColorComponent.gray['100']),
                    const ShowWalletWidget(showButton: true),
                    const ProfileListTilesWidget()
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
        //                         Text("заказы")
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
