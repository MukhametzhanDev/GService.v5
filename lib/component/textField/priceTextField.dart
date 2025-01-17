import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceTextField extends StatefulWidget {
  final String? title;
  final value;
  final TextEditingController textEditingController;
  final bool? autofocus;
  final void Function(String value)? onChanged;
  final void Function(String? value) onSubmitted;

  const PriceTextField(
      {super.key,
      required this.textEditingController,
      @required this.autofocus,
      this.value,
      @required this.title,
      required this.onSubmitted,
      @required this.onChanged});

  @override
  State<PriceTextField> createState() => _PriceTextFieldState();
}

class _PriceTextFieldState extends State<PriceTextField> {
  CurrencyTextInputFormatter currencyTextInputFormatter =
      CurrencyTextInputFormatter(
          NumberFormat.currency(decimalDigits: 0, symbol: "", locale: 'kk'));
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        onChanged: widget.onChanged,
        onSubmitted: (value) {
          widget.onSubmitted(value);
        },
        // initialValue: widget.value ?? "",
        inputFormatters: [currencyTextInputFormatter],
        autofocus: widget.autofocus ?? false,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 14, height: 1.1),
        controller: widget.textEditingController,
        decoration: InputDecoration(hintText: widget.title ?? 'Введите цену'),
      ),
    );
  }
}
