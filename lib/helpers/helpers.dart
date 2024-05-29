import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestampToTime(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return DateFormat('HH:mm').format(dateTime);
}

String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

String capitalizeEach(String text) {
  return text.split(' ').map((word) => capitalize(word)).join(' ');
}

String formatDateTimeCustom(DateTime? dateTime,
    {String format = 'EEEE, d MMM yyyy', String ifnull = '-'}) {
  if (dateTime == null) {
    return ifnull;
  } else {
    final DateFormat formatter = DateFormat(format, "en_US");
    return formatter.format(dateTime);
  }
}
