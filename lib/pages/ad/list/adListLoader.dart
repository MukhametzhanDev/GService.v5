import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:shimmer/shimmer.dart';

class AdListLoader extends StatefulWidget {
  const AdListLoader({super.key});

  @override
  State<AdListLoader> createState() => _AdListLoaderState();
}

class _AdListLoaderState extends State<AdListLoader> {
  @override
  Widget build(BuildContext context) {
    double IMAGE_HEIGHT = 120.0;
    return ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [1, 2, 3].map((value) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(width: 6, color: Color(0xfff4f5f7)))),
            child: Shimmer.fromColors(
                baseColor: Color(0xffD1D5DB),
                highlightColor: Color(0xfff4f5f7),
                period: Duration(seconds: 1),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 110,
                            height: 24,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          Container(
                            width: 70,
                            height: 24,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                          )
                        ],
                      ),
                      Divider(height: 8),
                      Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 24,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8))),
                      Divider(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                height: IMAGE_HEIGHT,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8))),
                          ),
                          Divider(indent: 12),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                Divider(height: 8),
                                Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                Divider(height: 8),
                                Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 8),
                      Divider(height: 1, color: ColorComponent.gray['50']),
                      Divider(height: 8),
                      Container(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8))),
                    ],
                  ),
                )),
          );
        }).toList());
  }
}
