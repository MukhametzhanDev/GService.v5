import 'package:flutter/material.dart';
import 'package:gservice5/pages/ad/item/adItem.dart';
import 'package:gservice5/pages/ad/item/smallAdItem.dart';

class RecommendationAdList extends StatefulWidget {
  const RecommendationAdList({super.key});

  @override
  State<RecommendationAdList> createState() => _RecommendationAdListState();
}

class _RecommendationAdListState extends State<RecommendationAdList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text("Вам могут понравится",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
        SizedBox(height: 15),
        GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 0.98,
            mainAxisSpacing: 12,
            crossAxisSpacing: 8,
            padding: EdgeInsets.symmetric(horizontal: 15),
            children: List.generate(10, (index) => index).map((value) {
              return SmallAdItem(index: value);
            }).toList())
      ],
    );
  }
}
