import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/favoriteButton.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/stickers/showStickersList.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/item/adItem.dart';
import 'package:gservice5/pages/ad/list/adListPage.dart';

class AdListMain extends StatefulWidget {
  const AdListMain({super.key});

  @override
  State<AdListMain> createState() => _AdListMainState();
}

class _AdListMainState extends State<AdListMain> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("12 000 Объявлений",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, height: 1)),
            GestureDetector(
                onTap: () {}, child: SvgPicture.asset('assets/icons/right.svg')
                //  Container(
                //     height: 32,
                //     padding: EdgeInsets.symmetric(horizontal: 12),
                //     alignment: Alignment.center,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(8),
                //         color: ColorComponent.mainColor.withOpacity(.2)),
                //     child: Text("Все",
                //         style: TextStyle(
                //             fontSize: 12,
                //             fontWeight: FontWeight.w600,
                //             height: 1))),
                )
          ],
        ),
      ),
      // Divider(height: 8),
      // ListView.builder(
      //   shrinkWrap: true,
      //   physics: NeverScrollableScrollPhysics(),
      //   itemCount: 20,
      //   itemBuilder: (context, index) {
      // if (index == 3) {
      //   return Column(
      //     children: [
      //       AdItem(),
      //       CacheImage(
      //           url:
      //               "https://images.unsplash.com/photo-1721332153370-56d7cc352d63?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxfHx8ZW58MHx8fHx8",
      //           width: MediaQuery.of(context).size.width,
      //           height: 196,
      //           borderRadius: 0)
      //     ],
      //   );
      // }
      // return AdItem();
      // },
      // ),
    ]);
  }
}
