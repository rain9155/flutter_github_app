
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

}