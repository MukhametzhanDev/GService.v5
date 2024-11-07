
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class TimerButton extends StatefulWidget {
  final onPressed;
  const TimerButton({super.key, @required this.onPressed});

  @override
  State<TimerButton> createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  late Timer _timer;
  int _start = 59;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() => timer.cancel());
        } else {
          setState(() => _start--);
        }
      },
    );
  }

  void replaceTimer() {
    widget.onPressed();
    if (_start == 0) {
      setState(() => _start = 59);
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorTheme = ThemeColorComponent.ColorsTheme(context);
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
          onPressed: _start == 0 ? () => replaceTimer() : null,
          style: TextButton.styleFrom(
              backgroundColor: ColorTheme['white_black'],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Запросить код повторно${_start > 0 ? " (${_start.toString().padLeft(2, '0')})" : ""}",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )),
    );
  }
}