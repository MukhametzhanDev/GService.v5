import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class EmptyTransactionPage extends StatelessWidget {
  const EmptyTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/icons/payment.svg",
            width: 120, color: ColorComponent.gray['500']),
        const Divider(indent: 12),
        const Text("Ваши транзакции пока не отображаются",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const Divider(indent: 12),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "На данный момент у вас нет совершенных операций. Когда вы начнете проводить транзакции, они появятся здесь, и вы сможете отслеживать все действия в удобном формате.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 15, height: 1.5),
            )),
        const Divider(height: 100)
      ],
    );
  }
}
