import 'dart:async';

class UpdateAds {
  static Map<String, dynamic> _value = {"status": "pending", "package": false};

  static final StreamController<Map<String, dynamic>> _valueController =
      StreamController<Map<String, dynamic>>.broadcast(
          onListen: null, onCancel: null, sync: false);

  static Map<String, dynamic> get value => _value;

  static set value(Map<String, dynamic> newValue) {
    _value = newValue;
    _valueController.add(_value);
  }

  static set addValue(Map<String, dynamic> newValue) {
    _value.addAll(newValue);
    _valueController.add(_value);
  }

  static Stream<Map> get valueStream => _valueController.stream;
}
