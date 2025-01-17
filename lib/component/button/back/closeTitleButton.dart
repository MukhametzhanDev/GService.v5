import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';

class CloseTitleButton extends StatelessWidget {
  final String title;
  final onPressed;
  const CloseTitleButton({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final analytics = GetIt.I<FirebaseAnalytics>();

    return IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.padded),
        onPressed: () {
          onPressed == null ? Navigator.pop(context) : onPressed();

          analytics.logEvent(name: GAEventName.buttonClick, parameters: {
            GAKey.buttonName: GAParams.btnFilterClose
          }).catchError((e) {
            if (kDebugMode) {
              debugPrint(e);
            }
          });
        },
        icon: Row(
          children: [
            const Divider(indent: 10),
            SvgPicture.asset('assets/icons/close.svg', width: 22),
            const Divider(indent: 8),
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
          ],
        ));
  }
}
