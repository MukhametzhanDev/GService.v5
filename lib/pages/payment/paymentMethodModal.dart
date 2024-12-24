import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class PaymentMethodModal extends StatefulWidget {
  final String paymentId;
  const PaymentMethodModal({super.key, required this.paymentId});

  @override
  State<PaymentMethodModal> createState() => _PaymentMethodModalState();
}

class _PaymentMethodModalState extends State<PaymentMethodModal> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        child: Scaffold(
          appBar: AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              actions: const [CloseIconButton(iconColor: null, padding: true)],
              title: const Text("Способ оплаты")),
          body: Column(
            children: [
              ListTile(
                  trailing: SvgPicture.asset('assets/icons/right.svg'),
                  title: const Text("Карта (Visa/MasterCard)",
                      style: TextStyle(fontSize: 15))),
              Divider(height: 1, color: ColorComponent.gray['100']),
              ListTile(
                  trailing: SvgPicture.asset('assets/icons/right.svg'),
                  title: const Text("Личный счет", style: TextStyle(fontSize: 15))),
              Divider(height: 1, color: ColorComponent.gray['100']),
              ListTile(
                  trailing: SvgPicture.asset('assets/icons/right.svg'),
                  title: const Text("С оператором (Beeline, Tele2, Altel и др.)",
                      style: TextStyle(fontSize: 15)))
            ],
          ),
        ),
      ),
    );
  }
}
