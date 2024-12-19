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
    double imageHeight = 120.0;
    return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [1, 2, 3].map((value) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(width: 6, color: Color(0xfff4f5f7)))),
            child: Shimmer.fromColors(
                baseColor: const Color(0xffe5e7eb),
                highlightColor: const Color(0xfff4f5f7),
                period: const Duration(seconds: 1),
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
                      const Divider(height: 8),
                      Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 24,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8))),
                      const Divider(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                height: imageHeight,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8))),
                          ),
                          const Divider(indent: 12),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                const Divider(height: 8),
                                Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                const Divider(height: 8),
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
                      const Divider(height: 8),
                      Divider(height: 1, color: ColorComponent.gray['50']),
                      const Divider(height: 8),
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
