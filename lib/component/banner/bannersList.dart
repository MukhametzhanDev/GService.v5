import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/banner/viewBannerPage.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class BannersList extends StatefulWidget {
  final List data;
  const BannersList({super.key, required this.data});

  @override
  State<BannersList> createState() => _BannersListState();
}

class _BannersListState extends State<BannersList> {
  void showStories() {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ViewBannerPage(data: widget.data));
  }

  @override
  Widget build(BuildContext context) {
    return widget.data.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: CarouselSlider(
              options: CarouselOptions(
                  height: 80,
                  autoPlay: true,
                  viewportFraction: 160 / MediaQuery.of(context).size.width,
                  disableCenter: true,
                  initialPage: 1),
              items: widget.data.map((value) {
                return Builder(
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                          onTap: showStories,
                          child: CacheImage(
                              url: value['poster'],
                              width: 175,
                              height: 100,
                              borderRadius: 8)),
                    );
                  },
                );
              }).toList(),
            ),
          );
  }
}
