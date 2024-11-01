// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CacheImage extends StatelessWidget {
  final url;
  final double width;
  final double height;
  final borderRadius;
  const CacheImage(
      {super.key,
      @required this.url,
      required this.width,
      required this.height,
      @required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    // final ColorTheme = ThemeColorComponent.ColorsTheme(context);
    String urlForm = url.runtimeType == String ? url : url['url'];
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius.toDouble()),
      child: url == null
          ? Container()
          // ? SvgPicture.asset(
          //     'assets/icons/miniLogo.svg',
          //     color: ColorComponent.gray200,
          //     height: height / 3,
          //     width: height / 3,
          //   )
          : CachedNetworkImage(
              imageUrl: urlForm,
              width: width.toDouble(),
              height: height.toDouble(),
              // maxWidthDiskCache: width.round() * 2,
              // maxHeightDiskCache: height.round() * 2,
              // memCacheHeight: height,
              // memCacheWidth: width,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) {
                return Shimmer.fromColors(
                  baseColor: Color(0xffD1D5DB),
                  highlightColor: Color(0xfff4f5f7),
                  period: Duration(seconds: 1),
                  child: Container(
                      width: width.toDouble(),
                      height: height.toDouble(),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(borderRadius.toDouble()))),
                );
              },
              errorWidget: (context, url, error) {
                return Container();
                // Container(
                //   alignment: Alignment.center,
                //   // color: ThemeColor['surring_dark'],
                //   child: SvgPicture.asset(
                //     'assets/icons/miniLogo.svg',
                //     color: ColorComponent.gray200,
                //     height: height / 5,
                //     width: height / 5,
                //   ),
                // );
              }),
    );
  }
}
