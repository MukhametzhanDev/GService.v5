import 'dart:async';

import 'package:flutter/material.dart';

class GeneralStreams {
  const GeneralStreams._();

  static StreamController<Locale> langaugeStream =
      StreamController<Locale>.broadcast();
}
