import 'package:flutter/material.dart';
import 'package:gservice5/pages/application/smallApplicationItem.dart';

class RecommendationApplicationList extends StatefulWidget {
  const RecommendationApplicationList({super.key});

  @override
  State<RecommendationApplicationList> createState() =>
      _RecommendationApplicationListState();
}

class _RecommendationApplicationListState
    extends State<RecommendationApplicationList> {
  void showPage(int id) {}
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text("Похожие заявки",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
        SizedBox(height: 15),
        ListView.builder(
          shrinkWrap: true,
          itemCount: 10,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SmallApplicationItem(
                  onPressed: showPage, data: {}, position: "more"),
            );
          },
        )
      ],
    );
  }
}
