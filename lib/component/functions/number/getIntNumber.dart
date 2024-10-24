int getIntComponent(value) {
  int number = int.tryParse(value.replaceAll(RegExp(r'[^0-9\.]'), '')) ?? 0;
  return number;
}
