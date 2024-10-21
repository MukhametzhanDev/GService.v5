import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/image/cacheImage.dart';

class BannersList extends StatefulWidget {
  const BannersList({super.key});

  @override
  State<BannersList> createState() => _BannersListState();
}

class _BannersListState extends State<BannersList> {
  @override
  Widget build(BuildContext context) {
    List images = [
      "https://images.unsplash.com/photo-1701965232477-93e1e23c8fb1?q=80&w=3087&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1494078683441-c860e1e95f28?q=80&w=2971&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1494078683441-c860e1e95f28?q=80&w=2971&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ];
    return SizedBox(
      height: 80,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 80,
          autoPlay: true,
          viewportFraction: 160 / MediaQuery.of(context).size.width,
          disableCenter: true,
          initialPage: 1
        ),
        items: images.map((value) {
          return Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: GestureDetector(
                    child: CacheImage(
                        url: value, width: 175, height: 100, borderRadius: 8)),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
