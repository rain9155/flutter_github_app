import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';

class UserModel extends ChangeNotifier{

  String _token;

  Future<bool> isLogin() async{
    String token = await getToken();
    return token != null;
  }

  Future<String> getToken() async{
    if(_token == null){
      _token = await SharedPreferencesUtil.get(KEY_TOKEN);
    }
    return _token;
  }

  setToken(String token){
    _token = token;
    SharedPreferencesUtil.set(KEY_TOKEN, _token);
    notifyListeners();
  }

}