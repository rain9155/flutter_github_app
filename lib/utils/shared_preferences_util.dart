
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil{

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

  static Future<dynamic> get(String key) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key);
  }

  static Future<bool> getBool(String key, {defaultValue = false}) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool value = await sharedPreferences.get(key);
    return value?? defaultValue;
  }

  static remove(String key) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(key);
  }

}