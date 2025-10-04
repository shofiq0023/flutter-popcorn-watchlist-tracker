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
    _showToast(message, Color(0xFF059669), Colors.white);
  }

  static void showErrorToast(String message) {
    _showToast(message, Color(0xFFDC2626), Colors.white);
  }

  static void showInfoToast(String message) {
    _showToast(message, Color(0xFF3B82F6), Colors.white);
  }

  static void showWarningToast(String message) {
    _showToast(message, Color(0xFFF97316), Colors.white);
  }


}
