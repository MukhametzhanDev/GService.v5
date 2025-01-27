import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/priceTextField.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';
import 'package:gservice5/provider/adFilterProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PriceFilterModal extends StatefulWidget {
  final void Function(Map<String, dynamic> data) onChangedPrice;
  const PriceFilterModal({super.key, required this.onChangedPrice});

  @override
  State<PriceFilterModal> createState() => _PriceFilterModalState();
}

class _PriceFilterModalState extends State<PriceFilterModal> {
  TextEditingController fromPrice = TextEditingController();
  TextEditingController toPrice = TextEditingController();
  CurrencyTextInputFormatter currencyTextInputFormatter =
      CurrencyTextInputFormatter(
          NumberFormat.currency(decimalDigits: 0, symbol: "", locale: 'kk'));

  @override
  void initState() {
    addPrice();
    super.initState();
  }

  void addPrice() {
    Map data = Provider.of<AdFilterProvider>(context, listen: false).value;
    if (data.containsKey("price_from")) {
      fromPrice.text = currencyTextInputFormatter
          .formatString(data['price_from'].toString());
    }
    if (data.containsKey("price_to")) {
      toPrice.text =
          currencyTextInputFormatter.formatString(data['price_to'].toString());
    }
  }

  @override
  void dispose() {
    fromPrice.dispose();
    toPrice.dispose();
    super.dispose();
  }

  void verifyData() {
    int from = getIntComponent(fromPrice.text);
    int to = getIntComponent(toPrice.text);
    if (from != 0 && to != 0) {
      if (from > to) {
        SnackBarComponent()
            .showErrorMessage("context.localizations.price от не должна превышать цена до", context);
      } else {
        updateAdList();
      }
    } else {
      updateAdList();
    }
  }

  void updateAdList() {
    Map<String, dynamic> data = formattedData();
    Provider.of<AdFilterProvider>(context, listen: false).filterData = data;
    widget.onChangedPrice({});
    Navigator.pop(context);
  }

  Map<String, dynamic> formattedData() {
    Map<String, dynamic> data = {};
    int from = getIntComponent(fromPrice.text);
    int to = getIntComponent(toPrice.text);
    if (from != 0) data.addAll({"price_from": from});
    if (to != 0) data.addAll({"price_to": to});
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210 + MediaQuery.of(context).viewInsets.bottom,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:  Text(context.localizations.price),
          actions: const [CloseIconButton(iconColor: null, padding: true)],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                    child: PriceTextField(
                        textEditingController: fromPrice,
                        autofocus: true,
                        title: "От",
                        onSubmitted: (value) {})),
                const Divider(indent: 12),
                Expanded(
                    child: PriceTextField(
                        textEditingController: toPrice,
                        autofocus: false,
                        title: "До",
                        onSubmitted: (value) {}))
              ]),
              const Divider(height: 15),
              SizedBox(
                  height: 48,
                  child: Button(onPressed: verifyData, title: "Поиск"))
            ],
          ),
        ),
      ),
    );
  }
}
