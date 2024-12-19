import 'package:flutter/material.dart';

class EmailTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool? autofocus;
  final void Function() onSubmitted;

  const EmailTextField(
      {super.key,
      required this.textEditingController,
      @required this.autofocus,
      required this.onSubmitted});

  @override
  State<EmailTextField> createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: SizedBox(
        height: 48,
        child: TextField(
          onSubmitted: (value) {
            widget.onSubmitted();
          },
          autofocus: widget.autofocus ?? false,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          style: const TextStyle(fontSize: 14, height: 1.1),
          controller: widget.textEditingController,
          decoration: const InputDecoration(hintText: "Email"),
        ),
      ),
    );
  }
}
