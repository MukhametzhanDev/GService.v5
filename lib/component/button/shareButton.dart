// ShareButton

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/counter/counterClickStatistic.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatefulWidget {
  final int id;
  final bool hasAd;
  const ShareButton({super.key, required this.id, required this.hasAd});

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
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
      path: "ad/${widget.id}",
      // queryParameters: {'ad': widget.id.toString()},
    );
    final deepLink = uri.toString(); 

    Share.share(deepLink, subject: 'Ссылка на объявлении');
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
