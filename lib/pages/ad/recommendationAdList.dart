import 'package:flutter/material.dart';
import 'package:gservice5/pages/ad/adItem.dart';

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
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Text("Вам могут понравится",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
        Column(
          children: List.generate(10, (index) => index).map((value) {
            return AdItem();
          }).toList(),
        ),
      ],
    );
  }
}
