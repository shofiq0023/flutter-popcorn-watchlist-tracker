import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  /// Parse a String of DateTime to "dd, MMMM y" DateTime
  static DateTime strDateToDateTime(String strDate) {
    DateFormat format = DateFormat("dd, MMMM y");
    DateTime parsedDate = format.parse(strDate);

    return parsedDate;
  }

  /// Convert a DateTime into "dd, MMMM y" String
  static String dateTimeToStrDate(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }

    return DateFormat("dd, MMMM y").format(dateTime);
  }

  /// Convert a DateTime into "dd, MMMM y hh:mm a" String
  static String dateTimeToStrDateWithTime(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }

    return DateFormat("dd, MMMM y hh:mm a").format(dateTime);
  }

  static List<DropdownMenuItem<int>> getPriorityDropdown() {
    return [
      DropdownMenuItem(value: 1, child: Text("High Priority")),
      DropdownMenuItem(value: 2, child: Text("Medium Priority")),
      DropdownMenuItem(value: 3, child: Text("Normal Priority")),
    ];
  }
}
