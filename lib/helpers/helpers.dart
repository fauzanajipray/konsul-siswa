import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    final DateFormat formatter = DateFormat(format, "id_ID");
    return formatter.format(dateTime);
  }
}

Color? getColorStatus(String? status) {
  switch (status) {
    case 'pending':
      return Colors.blue;
    case 'accepted':
      return Colors.green;
    case 'rejected':
      return Colors.red;
    default:
      return null;
  }
}
