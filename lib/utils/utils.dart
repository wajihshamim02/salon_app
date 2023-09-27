import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';

class utils {
  static flushbarmessagered(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          forwardAnimationCurve: Curves.decelerate,
          flushbarPosition: FlushbarPosition.TOP,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: EdgeInsets.all(15),
          message: message,
          positionOffset: 8,
          borderRadius: BorderRadius.circular(8),
          backgroundColor: Colors.red,
          titleColor: Colors.white,
          duration: Duration(seconds: 2),
          icon: Icon(Icons.error, color: Colors.white),
        )..show(context));
  }

  static flushbarmessagegreen(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          forwardAnimationCurve: Curves.decelerate,
          flushbarPosition: FlushbarPosition.TOP,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: EdgeInsets.all(15),
          message: message,
          positionOffset: 8,
          borderRadius: BorderRadius.circular(8),
          backgroundColor: Colors.green,
          titleColor: Colors.white,
          duration: Duration(seconds: 2),
          icon: Icon(Icons.check_circle, color: Colors.white),
        )..show(context));
  }
}
