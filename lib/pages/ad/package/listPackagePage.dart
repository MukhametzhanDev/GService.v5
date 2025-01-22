import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/package/packageItem.dart';
import 'package:gservice5/pages/ad/package/previewItemWidget.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/payment/paymentMethodModal.dart';

class ListPackagePage extends StatefulWidget {
  final int categoryId;
  final int adId;
  final bool goBack;
  const ListPackagePage(
      {super.key,
      required this.categoryId,
      required this.adId,
      required this.goBack});

  @override
  State<ListPackagePage> createState() => _ListPackagePageState();
}

class _ListPackagePageState extends State<ListPackagePage> {
  List packages = [];
  // List promotions = [];
  Map? currentPackage;
  List stickers = [];
  int totalPrice = 0;

  final analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    getPackagesData();
    super.initState();
  }

  void getPackagesData() async {
    print(widget.categoryId);
    try {
      Response response = await dio.get("/ad-promotions",
          queryParameters: {"category_id": widget.categoryId});
      print(response.data);
      if (response.data['success']) {
        packages = response.data['data']['ad_packages'];
        // promotions = response.data['data']['ad_promotions'];
        stickers = response.data['data']['stickers'];
        setState(() {});

        await analytics.logViewItemList(
            itemListId: GAParams.listPackagePageId,
            itemListName: GAParams.listPackagePageName,
            items: packages
                .map((toElement) => AnalyticsEventItem(
                    itemName: toElement['title'],
                    itemId: toElement['id'].toString()))
                .toList());

        await analytics.logViewItemList(
            itemListId: GAParams.listPackagePageStickersId,
            itemListName: GAParams.listPackagePageStickersName,
            items: stickers
                .map((toElement) => AnalyticsEventItem(
                    itemName: toElement['title'],
                    itemId: toElement['id'].toString()))
                .toList());
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void postData() async {
    showModalLoader(context);
    try {
      Response response = await dio.post("/order/package", data: {
        "ad_id": widget.adId,
        "package_id": currentPackage?['id'],
        "sticker_id": stickers
            .where((element) => element['active'] ?? false)
            .map((e) => e['id'])
            .toList(),
      });
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        showModalBottomSheet(
            context: context,
            builder: (context) => PaymentMethodModal(
                    totalPrice: totalPrice,
                orderId: response.data['data'],
                data: getProduct(),
                typePurchase: "package")).then((value) {
          if (value != null) Navigator.pop(context, value);
        });

        analytics.logEvent(
            name: GAEventName.selectedPackageAd,
            parameters: {GAKey.screenName: GAParams.listPackagePage});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      print(e);
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  Map getProduct() {
    List stickersParam = stickers
        .where((element) => element['active'] ?? false)
        .map((e) => e)
        .toList();
    Map? param;
    if (currentPackage != null) {
      param = {"stickers": stickersParam, "package": currentPackage};
    }
    return param!;
  }

  void showSuccessfullyPage() {
    CreateData.data.clear();
    CreateData.images.clear();
    Navigator.pop(context, "ad");
    Navigator.pop(context, "ad");

    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.btnSubmitWithoutAds
    }).catchError((e) {
      if (kDebugMode) {
        debugPrint(e);
      }
    });
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => SuccessfullyAdPage(adId: widget.adId)));
  }

  void onChangedPackage(Map value) {
    if (value['id'] == currentPackage?['id']) {
      currentPackage = null;
      analytics.logSelectItem(
          itemListId: GAParams.listPackagePageId,
          itemListName: GAParams.listPackagePageName,
          parameters: {
            'active': 'false'
          },
          items: [
            AnalyticsEventItem(
                itemId: value['id'].toString(), itemName: value['title'])
          ]);
    } else {
      currentPackage = value;
      analytics.logSelectItem(
          itemListId: GAParams.listPackagePageId,
          itemListName: GAParams.listPackagePageName,
          parameters: {
            'active': 'true'
          },
          items: [
            AnalyticsEventItem(
                itemId: value['id'].toString(), itemName: value['title'])
          ]);
    }
    setState(() {});
  }

  int stickerCount = 0;

  void onChangedStickers(Map value) {
    int price = value['price'];
    if (value['active'] ?? false) {
      totalPrice -= price;
      stickerCount -= 1;
      value['active'] = false;
    } else {
      if (stickerCount < 6) {
        totalPrice += price;
        stickerCount += 1;
        value['active'] = true;
      } else {
        SnackBarComponent().showErrorMessage(
            "Вы можете прикрепить не более 6 стикеров", context);
      }
    }
    setState(() {});

    analytics.logSelectItem(
        items: [
          AnalyticsEventItem(
              itemId: value['id'].toString(), itemName: value['title'])
        ],
        itemListId: GAParams.listPackagePageStickersId,
        itemListName: GAParams.listPackagePageStickersName).catchError((e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    });
  }

  void onChangedPromotions(Map value) {
    bool active = value['active'] ?? false;
    if (active) {
      value['active'] = false;
    } else {
      value['active'] = true;
    }
    setState(() {});
  }

  void validateData() {
    if (currentPackage == null) {
      SnackBarComponent().showErrorMessage("Выберите пакеты", context);
    } else {
      postData();
    }

    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.btnSubmitForPackage,
      GAKey.screenName: GAParams.listPackagePage
    }).catchError((e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    });
  }

  List getStickers() {
    List stickersParam = stickers
        .where((element) => element['active'] ?? false)
        .map((e) => e)
        .toList();
    return stickersParam;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: widget.goBack,
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: widget.goBack ? const BackIconButton() : Container(),
              leadingWidth: widget.goBack ? null : 0,
              title: const Text("Продвижение")),
          body: packages.isEmpty
              ? const LoaderComponent()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                                children: packages.map((value) {
                              return PackageItem(
                                  data: value,
                                  onChangedPackage: onChangedPackage,
                                  active: value['id'] == currentPackage?['id']);
                            }).toList()),

                            // AddStickersWidget(
                            //     rubricId: widget.rubricId,
                            //     onChangedStickers: onChangedStickers),

                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     currentPackage != null
                            //         ? Container()
                            //         : Column(
                            //             children: promotions.map((value) {
                            //             bool active = value['active'] ?? false;
                            //             return GestureDetector(
                            //               onTap: () => onChangedPromotions(value),
                            //               child: Container(
                            //                 margin: const EdgeInsets.only(top: 12),
                            //                 padding: const EdgeInsets.symmetric(
                            //                     horizontal: 14, vertical: 14),
                            //                 decoration: BoxDecoration(
                            //                     color: Colors.white,
                            //                     boxShadow: [
                            //                       BoxShadow(
                            //                           color: Colors.black
                            //                               .withOpacity(.1),
                            //                           blurRadius: 5,
                            //                           offset: const Offset(0, 1))
                            //                     ],
                            //                     borderRadius:
                            //                         BorderRadius.circular(12),
                            //                     border: Border.all(
                            //                         color: const Color(0xffeeeeee),
                            //                         width: 1)),
                            //                 child: Row(
                            //                   children: [
                            //                     CheckBoxWidget(active: active),
                            //                     const Divider(indent: 16),
                            //                     Expanded(
                            //                       child: Column(
                            //                         crossAxisAlignment:
                            //                             CrossAxisAlignment.start,
                            //                         children: [
                            //                           Text(
                            //                             "${value['value']} ${promotionTitle[value['id']]}",
                            //                             style: const TextStyle(
                            //                                 fontSize: 16),
                            //                           ),
                            //                           const Divider(height: 6),
                            //                           Text(
                            //                             "${priceFormat(value['price'])} ₸",
                            //                             style: const TextStyle(
                            //                                 fontWeight:
                            //                                     FontWeight.w600),
                            //                           )
                            //                         ],
                            //                       ),
                            //                     ),
                            //                     SvgPicture.network(
                            //                       value['icon'],
                            //                       width: 20,
                            //                     )
                            //                   ],
                            //                 ),
                            //               ),
                            //             );
                            //           }).toList())
                            //   ],
                            // ),
                            const Divider(height: 24),
                            const Text("Стикеры по 100 ₸",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                            const Divider(height: 12),
                            Wrap(
                                alignment: WrapAlignment.start,
                                children: stickers.map((value) {
                                  bool active = value['active'] ?? false;
                                  return GestureDetector(
                                    onTap: () => onChangedStickers(value),
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 10, bottom: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                            color: active
                                                ? ColorComponent.mainColor
                                                : Colors.white,
                                            border: Border.all(
                                                width: 1,
                                                color: active
                                                    ? ColorComponent.mainColor
                                                    : const Color(0xffeeeeee)),
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Text(value['title'].toString())),
                                  );
                                }).toList()),
                            const Divider(height: 24),
                            const Text("Предпоказ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                            const Divider(height: 12),
                          ],
                        ),
                      ),
                      PreviewItemWidget(
                        adId: widget.adId,
                        package: currentPackage,
                        stickers: getStickers(),
                        // promotions: promotions
                      ),
                      const SizedBox(height: 12),
                      Button(
                          onPressed: validateData,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          title:
                              "Подать за ${totalPrice + (currentPackage?['price'] ?? 0)} ₸"),
                      const SizedBox(height: 12),
                      Button(
                          onPressed: showSuccessfullyPage,
                          title: "Подать без рекламы",
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          backgroundColor: Colors.white,
                          titleColor: Colors.black),
                      SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 15),
                    ],
                  ),
                ),
        ));
  }
}

Map promotionTitle = {
  1: "дней на GService.kz",
  2: "раз поднятие в поиске",
  3: "раз в блоке «Топ»",
  4: "раз в блоке «Премиум»"
};
