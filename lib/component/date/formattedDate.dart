import 'package:intl/intl.dart';

String formattedDate(String isoDate, String format) {
  DateTime dateTime = DateTime.parse(isoDate);
  String formattedDate = DateFormat(format, 'ru_RU').format(dateTime);
  return formattedDate;
}
