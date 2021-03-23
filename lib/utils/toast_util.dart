
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil{

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

  static showSnackBar(BuildContext context, String msg, {
    Duration duration = const Duration(seconds: 2),
    SnackBarAction action,
  }){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        action: action,
        duration: duration,
        backgroundColor: Theme.of(context).primaryColor,
      )
    );
  }

}