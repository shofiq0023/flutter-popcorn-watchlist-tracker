import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  static void _showToast(String message, Color color, Color textColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: color,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  static void showSuccessToast(String message) {
    // Secondary green color option: Color(0xFF059669)

    _showToast(message, Color(0xFF10B981), Colors.white);
  }

  static void showErrorToast(String message) {
    // Secondary red color option: Color(0xFFDC2626)

    _showToast(message, Color(0xFFEF4444), Colors.white);
  }

  static void showInfoToast(String message) {
    // Secondary red color option: Color(0xFF3B82F6)

    _showToast(message, Color(0xFF0EA5E9), Colors.white);
  }

  static void showWarningToast(String message) {
    // Secondary red color option: Color(0xFFF97316)

    _showToast(message, Color(0xFFEAB308), Colors.white);
  }


}
