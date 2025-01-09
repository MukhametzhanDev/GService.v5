import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/author/business/socialNetworkWidget.dart';
import 'package:readmore/readmore.dart';

class ViewAboutBusinessPage extends StatelessWidget {
  final Map data;
  const ViewAboutBusinessPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          data['description'] == "" || data['description'] == null
              ? const SizedBox(height: 8)
              : Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 12),
                  child: ReadMoreText(
                    data['description'] ?? "",
                    trimMode: TrimMode.Line,
                    trimLines: 5,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                    trimCollapsedText: ' читать дальше',
                    trimExpandedText: ' cкрыть',
                    lessStyle: TextStyle(
                        fontSize: 14,
                        color: ColorComponent.blue['500'],
                        fontWeight: FontWeight.w500),
                    moreStyle: TextStyle(
                        fontSize: 14,
                        color: ColorComponent.blue['500'],
                        fontWeight: FontWeight.w500),
                  ),
                ),
          Text("г. ${data['city']['title']}",
              style: const TextStyle(fontSize: 15, height: 1.5)),
          // InfoButton(
          //     ,
          //     widget.data['city']['title'],
          //     () {}),
          InfoButton(
              Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                      color: ColorComponent.red['500'],
                      borderRadius: BorderRadius.circular(5))),
              "Закрыто до завтра",
              () {}),
          const Divider(height: 8),
          SocialNetworkWidget(data: data['contacts'])
        ],
      ),
    );
  }

  Widget InfoButton(Widget leading, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  leading,
                  const Divider(indent: 10),
                  Text(title, style: const TextStyle(fontSize: 15, height: 1.5)),
                ],
              ),
            ),
            SvgPicture.asset("assets/icons/right.svg")
          ],
        ),
      ),
    );
  }
}
