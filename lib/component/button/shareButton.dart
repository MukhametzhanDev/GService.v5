// ShareButton

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/counter/counterClickStatistic.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

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
    } else {
      await getCountClick(widget.id, "share", true);
    }
    // await GetCountClick().postData(widget.id, widget.hasAd, "share");

    await analytics.logEvent(name: GAEventName.buttonClick, parameters: {
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
