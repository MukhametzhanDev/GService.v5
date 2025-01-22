// ShareButton

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/counter/counterClickStatistic.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatefulWidget {
  final int id;
  final bool hasAd;
  final String? frompage;
  const ShareButton(
      {super.key, required this.id, required this.hasAd, this.frompage});

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  final analytics = FirebaseAnalytics.instance;

  void shared() async {
    print(widget.hasAd);
    if (widget.hasAd) {
      shareAd();
    } else {}
    await getCountClick(widget.id, "share", true);
  }

  void shareAd() {
    final uri = Uri(
      scheme: 'https',
      host: 'v4.gservice.kz',
      path: "ad",
      // queryParameters: {'ad': widget.id.toString()},
    );
    final deepLink = uri.toString(); 

    Share.share(deepLink, subject: 'Ссылка на объявлении');

      analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.itemId: widget.id.toString(),
      GAKey.buttonName: GAParams.icBtnShare,
      GAKey.screenName: widget.frompage ?? ''
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: shared,
      child: Container(
        height: 32,
        width: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: ColorComponent.mainColor.withOpacity(.1)),
        child: SvgPicture.asset('assets/icons/share.svg'),
      ),
    );
  }
}
