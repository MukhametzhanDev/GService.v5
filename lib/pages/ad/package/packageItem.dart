import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class PackageItem extends StatelessWidget {
  final Map data;
  final void Function(Map value) onChangedPackage;
  final bool active;
  PackageItem(
      {super.key,
      required this.data,
      required this.onChangedPackage,
      required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 5,
                offset: Offset(0, 1))
          ],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: Color(0xffeeeeee),
              //  hexToColor(data['color']),
              width: 1)),
      child: Stack(children: [
        Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text("Продвижение",
                    // data['title'],
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                Container(
                  width: 28,
                  margin: EdgeInsets.only(left: 8),
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: ColorComponent.blue['500']),
                  child: Text("x5",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ]),
              SizedBox(height: 8),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(5, (index) => index)
                      .map((detail) => Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(children: [
                            SvgPicture.asset("assets/icons/fire.svg"),
                            SizedBox(width: 8),
                            Text("28 дней на GService.kz",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400))
                          ])))
                      .toList()),
              SizedBox(height: 16),
              Row(children: [
                Text("${priceFormat(5000)} ₸",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                SizedBox(width: 12),
                Text("${priceFormat(6000)} ₸",
                    style: TextStyle(
                        fontSize: 17,
                        color: ColorComponent.gray['500'],
                        decorationColor: ColorComponent.gray['500'],
                        decoration: TextDecoration.lineThrough))
              ]),
              SizedBox(height: 16),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    // color: active ? Colors.white : ColorComponent.mainColor,
                    border: Border.all(
                        width: active ? 1 : 0,
                        color:
                            active ? ColorComponent.mainColor : Colors.white)),
                child: Button(
                    onPressed: () {
                      onChangedPackage(data);
                    },
                    title: active ? "Выбрано" : "Выбрать",
                    backgroundColor:
                        active ? Colors.white : ColorComponent.mainColor,
                    titleColor:
                        active ? ColorComponent.gray['500'] : Colors.black),
              )
            ])),
        data['discount'] == 0
            ? Container()
            : Positioned(
                right: 0,
                child: ClipPath(
                  clipper: CustomTriangleClipper(),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(10)),
                        color: Color(0xffE02424)),
                  ),
                ),
              ),
        data['discount'] == 0
            ? Container()
            : Positioned(
                right: 0,
                top: 9,
                child: Transform.rotate(
                  angle: 0.785,
                  child: Text(
                    "-30%",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ))
      ]),
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
