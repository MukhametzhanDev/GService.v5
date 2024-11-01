import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/closeIconButton.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class InfoTypeAccountModal extends StatefulWidget {
  final Map data;
  const InfoTypeAccountModal({super.key, required this.data});

  @override
  State<InfoTypeAccountModal> createState() => _InfoTypeAccountModalState();
}

class _InfoTypeAccountModalState extends State<InfoTypeAccountModal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Container(),
          leadingWidth: 0,
          title: Text(widget.data['title']),
          actions: [CloseIconButton(iconColor: null, padding: true)]),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CacheImage(
                url:
                    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dXNlcnxlbnwwfHwwfHx8MA%3D%3D",
                width: MediaQuery.of(context).size.width - 32,
                height: (MediaQuery.of(context).size.width - 32) / 2.4,
                borderRadius: 12),
            Divider(height: 16),
            Text("Остались вопросы по типу кабинета?",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
            Divider(height: 16),
            Container(
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorComponent.mainColor.withOpacity(.1)),
              child: Row(
                children: [
                  SvgPicture.asset("assets/icons/headsetOutline.svg"),
                  Divider(indent: 8),
                  Text("Обратиться в поддержку GService",
                      style: TextStyle(fontWeight: FontWeight.w500))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
