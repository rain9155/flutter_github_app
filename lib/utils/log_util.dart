
import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/env.dart';

class LogUtil{

  static printObject(String tag, Object object){
    if(DEBUG){
      print('$tag ===> $object');
    }
  }

  static printString(String tag, String msg){
    if(DEBUG){
      debugPrint('$tag ===> $msg');
    }
  }

}