// ShareButton

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class ShareButton extends StatefulWidget {
  final int id;
  final bool hasAd;
  const ShareButton({super.key, required this.id, required this.hasAd});

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  void shareData() async {
    // await GetCountClick().postData(widget.id, widget.hasAd, "share");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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