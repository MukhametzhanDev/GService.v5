import 'package:flutter/material.dart';

class FadeTransitionClass {
  Route showFadeTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: page);
      },
    );
  }
}
