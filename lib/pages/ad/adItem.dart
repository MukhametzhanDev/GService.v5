import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/modal/contact/shortContactModal.dart';
import 'package:gservice5/component/stickers/showStickersList.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/viewAdPage.dart';

class AdItem extends StatefulWidget {
  const AdItem({super.key});

  @override
  State<AdItem> createState() => _AdItemState();
}

class _AdItemState extends State<AdItem> {
  void showAdPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ViewAdPage(id: 0)));
  }

  @override
  Widget build(BuildContext context) {
    double IMAGE_HEIGHT = 120.0;
    return GestureDetector(
        onTap: showAdPage,
        onLongPress: () => onLongPressShowNumber({}, context),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width: 6, color: Color(0xfff4f5f7)))),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Гусеничные экскаватор экскаватор экскаватор",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ColorComponent.blue['700']),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    height: 24,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: ColorComponent.mainColor,
                        borderRadius: BorderRadius.circular(4)),
                    child: Text("Аренда",
                        style: TextStyle(
                            height: 1,
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                  ),
                  // Row(
                  // children: [
                  // Divider(indent: 8),
                  // FavoriteButton()
                  //  ],
                  //  )
                ],
              ),
              Divider(height: 8),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black),
                        children: [
                      TextSpan(text: "3 000 ", style: TextStyle(fontSize: 15)),
                      TextSpan(
                          text: "тг./час",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14)),
                    ])),
                Text("  |  "),
                RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                        children: [
                      TextSpan(text: "25 000 ", style: TextStyle(fontSize: 15)),
                      TextSpan(
                          text: "тг./смена",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14)),
                    ])),
              ]),
              Divider(height: 12),
              SizedBox(
                height: IMAGE_HEIGHT,
                child: Row(
                  children: [
                    CacheImage(
                        url:
                            "https://images.unsplash.com/photo-1546081476-e3246476f65c?q=80&w=2970&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        width: MediaQuery.of(context).size.width / 2.2,
                        height: IMAGE_HEIGHT,
                        borderRadius: 8),
                    Divider(indent: 12),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("JCB 3CX",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        Divider(height: 8),
                        Text(
                            "На заказы от 3-х смен мы предоставляем скидку. Вся техника находится у нас в собственности, работают опытные операторы и качественно",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: ColorComponent.gray['600'],
                                fontSize: 13)),
                        Divider(height: 8),
                        Text("31 октября",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: ColorComponent.gray["500"])),
                      ],
                    ))
                  ],
                ),
              ),
              Divider(height: 10),
              ShowStickersList(),
              Divider(height: 10),
              Divider(height: 1, color: ColorComponent.gray['100']),
              Divider(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/pin.svg',
                          color: ColorComponent.gray["500"], width: 16),
                      const SizedBox(width: 4),
                      Text("г. Алматы",
                          style: TextStyle(
                              color: ColorComponent.gray["500"],
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/eye.svg',
                        width: 16,
                        color: ColorComponent.gray["500"],
                      ),
                      Divider(indent: 4),
                      Text(
                        numberFormat(1200),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: ColorComponent.gray["500"]),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
