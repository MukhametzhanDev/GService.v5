import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/modal/modalBottomSheetWrapper.dart';

class AddEmptySelectModal extends StatefulWidget {
  const AddEmptySelectModal({super.key});

  @override
  State<AddEmptySelectModal> createState() => _AddEmptySelectModalState();
}

class _AddEmptySelectModalState extends State<AddEmptySelectModal> {
  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrapper(builder: (context, physic) {
      return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: const [CloseIconButton(iconColor: null, padding: true)]),
        body: SingleChildScrollView(physics: physic),
      );
    });
  }
}
