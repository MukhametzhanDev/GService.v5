import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/gen/assets.gen.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class EmptyLeadsListPage extends StatefulWidget {
  const EmptyLeadsListPage({super.key});

  @override
  State<EmptyLeadsListPage> createState() => _EmptyLeadsListPageState();
}

class _EmptyLeadsListPageState extends State<EmptyLeadsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(Assets.icons.phoneOutline,
              width: 120, color: ColorComponent.gray['500']),
          const Divider(indent: 12),
          Text(context.localizations.no_requests_yet,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const Divider(height: 20),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                context.localizations.noCallbackRequestsText,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontSize: 15, height: 1.5),
              )),
          const Divider(height: 100),
        ],
      ),
    );
  }
}
