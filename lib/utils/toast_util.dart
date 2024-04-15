
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil{

  ToastUtil._();

  static showToast(String msg, {
    length = Toast.LENGTH_SHORT,
    gravity = ToastGravity.BOTTOM
  }){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: length,
      gravity: gravity
    );
  }

  static showSnackBar(BuildContext context, {
    required String msg,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
    backgroundColor
  }){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        action: action,
        duration: duration,
        backgroundColor: backgroundColor?? Theme.of(context).primaryColor,
      )
    );
  }

}