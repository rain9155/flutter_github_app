
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil{

  SharedPreferencesUtil._();

  static setString(String key, String value) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }

  static setInt(String key, int value) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(key, value);
  }

  static setBool(String key, bool value) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setBool(key, value);
  }

  static setDouble(String key, double value) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setDouble(key, value);
  }

  static Future<dynamic> get(String key, {defaultValue}) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key)?? defaultValue;
  }

  static Future<bool> getBool(String key, {defaultValue = false}) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key)?? defaultValue;
  }

  static Future<double> getDouble(String key, {defaultValue = 0.0}) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key)?? defaultValue;
  }

  static Future<int> getInt(String key, {defaultValue = 0}) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key)?? defaultValue;
  }


  static remove(String key) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(key);
  }

}