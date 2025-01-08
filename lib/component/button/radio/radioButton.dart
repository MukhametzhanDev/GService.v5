import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class RadioButtonWidget extends StatelessWidget {
  final bool active;
  final String title;
  const RadioButtonWidget(
      {super.key, required this.active, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => onChanged(value['id']),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Container(
            width: 24,
            margin: const EdgeInsets.only(right: 12),
            height: 24,
            decoration: BoxDecoration(
                color: ColorComponent.gray['50'],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    width: active ? 5 : 1,
                    color: active
                        ? ColorComponent.blue['500']!
                        : ColorComponent.gray['300']!)),
          ),
          Expanded(
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w500)))
        ]),
      ),
    );
  }
}
