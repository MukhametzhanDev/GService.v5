import 'package:flutter/material.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool? autofocus;
  final void Function() onSubmitted;
  const PhoneTextField(
      {super.key,
      required this.textEditingController,
      @required this.autofocus,
      required this.onSubmitted});

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: SizedBox(
        height: 48,
        child: TextField(
          autofocus: widget.autofocus ?? false,
          inputFormatters: [maskFormatter],
          keyboardType: TextInputType.number,
          autofillHints: const [AutofillHints.telephoneNumber],
          onChanged: (value) {
            if (value.length == 18) closeKeyboard();
          },
          style: TextStyle(fontSize: 14, height: 1.1),
          onSubmitted: (value) => widget.onSubmitted(),
          controller: widget.textEditingController,
          decoration: InputDecoration(hintText: "+7"),
        ),
      ),
    );
  }
}
