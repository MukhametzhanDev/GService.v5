import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/checkBox/checkBoxWidget.dart';
import 'package:gservice5/pages/ad/package/packageItem.dart';
import 'package:gservice5/pages/ad/package/previewItemWidget.dart';
import 'package:gservice5/pages/create/data/createData.dart';

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
  List promotions = [];
  Map? currentPackage;
  List stickers = [];
  int totalPrice = 0;

  @override
  void initState() {
    getPackagesData();
    super.initState();
  }

  void getPackagesData() async {
    try {
      Response response = await dio.get("/ad-promotions",
          queryParameters: {"category_id": widget.categoryId});
      print(response.data);
      if (response.data['success']) {
        packages = response.data['data']['ad_packages'];
        promotions = response.data['data']['ad_promotions'];
        stickers = response.data['data']['stickers'];
        setState(() {});
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void showSuccessfullyPage() {
    CreateData.data.clear();
    CreateData.images.clear();
    Navigator.pop(context, "ad");
    Navigator.pop(context, "ad");
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => SuccessfullyAdPage(adId: widget.adId)));
  }

  void onChangedPackage(Map value) {
    if (value['id'] == currentPackage?['id']) {
      currentPackage = null;
    } else {
      currentPackage = value;
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
      if (stickerCount < 3) {
        totalPrice += price;
        stickerCount += 1;
        value['active'] = true;
      } else {
        SnackBarComponent().showErrorMessage(
            "Вы можете прикрепить не более 3 стикеров", context);
      }
    }
    setState(() {});
    print(stickers);
  }

  void validateData() {
    if (currentPackage == null || stickers.isEmpty) {
      SnackBarComponent()
          .showErrorMessage("Выберите пакеты или стикеры", context);
    } else {}
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
                  padding: const EdgeInsets.all(16.0),
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

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          currentPackage != null
                              ? Container()
                              : Column(
                                  children: promotions.map((value) {
                                  bool active = value['active'] ?? false;
                                  return GestureDetector(
                                    onTap: () => onChangedStickers(value),
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 12),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 14),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.1),
                                                blurRadius: 5,
                                                offset: const Offset(0, 1))
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: const Color(0xffeeeeee),
                                              width: 1)),
                                      child: Row(
                                        children: [
                                          const CheckBoxWidget(active: true),
                                          const Divider(indent: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${value['value']} ${promotionTitle[value['id']]}",
                                                  style:
                                                      const TextStyle(fontSize: 16),
                                                ),
                                                const Divider(height: 6),
                                                Text(
                                                  "${priceFormat(value['price'])} ₸",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                          ),
                                          SvgPicture.network(
                                            value['icon'],
                                            width: 20,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList())
                        ],
                      ),
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
                                  margin:
                                      const EdgeInsets.only(right: 10, bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                      color: active
                                          ? ColorComponent.mainColor
                                          : Colors.white,
                                      border: Border.all(
                                          width: 1,
                                          color: active
                                              ? ColorComponent.mainColor
                                              : const Color(0xffeeeeee)),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Text(value['title'].toString())),
                            );
                          }).toList()),
                      const Divider(height: 24),
                      const Text("Предпоказ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const Divider(height: 12),
                      PreviewItemWidget(
                          adId: widget.adId,
                          package: currentPackage,
                          stickers: stickers),
                      const SizedBox(height: 12),
                      Button(
                          onPressed: validateData,
                          title:
                              "Подать за ${totalPrice + (currentPackage?['price'] ?? 0)} ₸"),
                      const SizedBox(height: 12),
                      Button(
                          onPressed: showSuccessfullyPage,
                          title: "Подать без рекламы",
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
