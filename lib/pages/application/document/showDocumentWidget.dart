import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class ShowDocumentWidget extends StatefulWidget {
  const ShowDocumentWidget({super.key});

  @override
  State<ShowDocumentWidget> createState() => _ShowDocumentWidgetState();
}

class _ShowDocumentWidgetState extends State<ShowDocumentWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.localizations.attached_documents_optional,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const Divider(height: 8),
        Column(
            children: [1, 2].map((value) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xfff4f4f4)),
            child: Row(
              children: [
                GestureDetector(
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ColorComponent.mainColor),
                    child: SvgPicture.asset("assets/icons/download.svg"),
                  ),
                ),
                const Divider(indent: 16),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Фотография карьера Whatsapp and IMG",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Divider(height: 6),
                          Text("123.24 MB, JPG",
                              style:
                                  TextStyle(color: ColorComponent.gray["500"]))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }).toList())
      ],
    );
  }
}
