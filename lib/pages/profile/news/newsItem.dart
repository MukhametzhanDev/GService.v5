import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/date/formattedDate.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/profile/news/viewNewsPage.dart';

class NewsItem extends StatelessWidget {
  final Map data;
  const NewsItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final analytics = GetIt.I<FirebaseAnalytics>();

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewNewsPage(id: data['id'])));

        analytics.logSelectContent(
            contentType: GAContentType.news,
            itemId: data['id'].toString(),
            parameters: {
              GAKey.screenName: GAParams.allNewsPage
            }).catchError((e) {
          if (kDebugMode) {
            debugPrint(e);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom:
                    BorderSide(width: 1, color: ColorComponent.gray['100']!))),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                CacheImage(
                    url: data["poster"],
                    width: 120,
                    height: 94,
                    borderRadius: 8),
                const Divider(indent: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data["title"],
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const Divider(height: 12),
                        Row(
                          children: [
                            Text(
                                formattedDate(
                                    data["created_at"], "dd MMMM yyyy, HH:mm"),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: ColorComponent.gray['500'])),
                            const Divider(indent: 24),
                            SvgPicture.asset("assets/icons/eye.svg"),
                            const Divider(indent: 4),
                            Text(data["views"].toString(),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: ColorComponent.gray['500'])),
                          ],
                        ),
                      ]),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
