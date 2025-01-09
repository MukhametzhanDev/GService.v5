import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/application/leasing/createApplicationLeasingModal.dart';

class CreateApplicationLeasingWidget extends StatefulWidget {
  final Map data;
  const CreateApplicationLeasingWidget({super.key, required this.data});

  @override
  State<CreateApplicationLeasingWidget> createState() =>
      _CreateApplicationLeasingWidgetState();
}

class _CreateApplicationLeasingWidgetState
    extends State<CreateApplicationLeasingWidget> {
  void showPage() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return CreateApplicationLeasingModal(data: widget.data);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text("Оставить заявку на лизинг",
        //     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        // Divider(indent: 16),
        SizedBox(
          height: 46,
          child: TextButton(
              onPressed: showPage,
              style: TextButton.styleFrom(
                  backgroundColor: ColorComponent.red2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Container(
                alignment: Alignment.center,
                constraints: const BoxConstraints(minHeight: 40, maxHeight: 49),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Оставить заявку на лизинг",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white))
                  ],
                ),
              )),
        )
      ],
    );
  }
}
