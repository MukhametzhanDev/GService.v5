import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/package/listPackagePage.dart';

class PackageItem extends StatelessWidget {
  final Map data;
  final void Function(Map value) onChangedPackage;
  final bool active;
  const PackageItem(
      {super.key,
      required this.data,
      required this.onChangedPackage,
      required this.active});

  int getDiscount() {
    if (data['old_price'] == 0 || data['old_price'] == null) {
      return 0;
    } else {
      double discount = data['price'] * 100 / data['old_price'];
      discount = 100 - discount;
      return discount.round();
    }
  }

  @override
  Widget build(BuildContext context) {
    String title =
        data['title'].toString().replaceAll(RegExp(r"\bX\d+\b"), "").trim();
    List promotions = data['promotions'];
    bool showPrice = data['old_price'] == 0 || data['old_price'] == null;
    return GestureDetector(
      onTap: () => onChangedPackage(data),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  blurRadius: 5,
                  offset: const Offset(0, 1))
            ],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xffeeeeee),
                //  hexToColor(data['color']),
                width: 1)),
        child: Stack(children: [
          Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(title,
                          // data['title'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        height: 28,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: ColorComponent.blue['500']),
                        child: Text(data['title'].toString().split(" ").last,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    Text(data['description']),
                    const SizedBox(height: 12),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: promotions.map((detail) {
                          if (detail['icon'] == null || detail['icon'] == "") {
                            return Container();
                          } else {
                            return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(children: [
                                  SvgPicture.network(detail['icon'] ?? "",
                                      width: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                      "${detail['value']} ${promotionTitle[detail['id']]}",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400))
                                ]));
                          }
                        }).toList()),
                    const SizedBox(height: 16),
                    Row(children: [
                      Text("${priceFormat(data['price'])} ₸",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 12),
                      showPrice
                          ? Container()
                          : Text("${priceFormat(data['old_price'])} ₸",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: ColorComponent.gray['500'],
                                  decorationColor: ColorComponent.gray['500'],
                                  decoration: TextDecoration.lineThrough)),
                      const Spacer(),
                      showPrice
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                  "Экономия ${priceFormat(data['old_price'] - data['price'])} ₸",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: ColorComponent.blue['600'])),
                            )
                    ]),
                    const SizedBox(height: 16),
                    Container(
                      height: 42,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          // color: active ? Colors.white : ColorComponent.mainColor,
                          border: Border.all(
                              width: active ? 1 : 0,
                              color: active
                                  ? ColorComponent.mainColor
                                  : Colors.white)),
                      child: Button(
                          onPressed: () {
                            onChangedPackage(data);
                          },
                          title: active ? "Выбрано" : "Выбрать",
                          backgroundColor:
                              active ? Colors.white : ColorComponent.mainColor,
                          titleColor: active
                              ? ColorComponent.gray['500']
                              : Colors.black),
                    )
                  ])),
          showPrice
              ? Container()
              : Positioned(
                  right: 0,
                  child: ClipPath(
                    clipper: CustomTriangleClipper(),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(10)),
                          color: Color(0xffE02424)),
                    ),
                  ),
                ),
          showPrice
              ? Container()
              : Positioned(
                  right: 0,
                  top: 9,
                  child: Transform.rotate(
                    angle: 0.785,
                    child: Text(
                      "${getDiscount()}%",
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ))
        ]),
      ),
    );
  }
}

class CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
