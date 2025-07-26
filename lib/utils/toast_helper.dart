import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  static void showSuccessToast(String message) {
    // Secondary green color option: Color(0xFF059669)

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Color(0xFF10B981),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showErrorToast(String message) {
    // Secondary red color option: Color(0xFFDC2626)

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Color(0xFFEF4444),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
