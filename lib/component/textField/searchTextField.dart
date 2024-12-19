import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class SearchTextField extends StatefulWidget {
  final String title;
  final void Function(String title) onChanged;
  const SearchTextField(
      {super.key, required this.title, required this.onChanged});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        style: const TextStyle(fontSize: 14, height: 1.1),
        onChanged: widget.onChanged,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
            hintText: widget.title,
            prefixIconConstraints: const BoxConstraints(minWidth: 42),
            prefixIcon: SvgPicture.asset(
              'assets/icons/searchOutline.svg',
              color: ColorComponent.gray['500'],
            )),
      ),
    );
  }
}
