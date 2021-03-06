import 'package:bloc/bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/main.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';

class UserCubit extends Cubit<String?> {

  UserCubit() : super(null){
    setName(AppConfig.name);
  }

  String? get name => state;

  setName(String? name){
    SharedPreferencesUtil.setString(KEY_NAME, name == null ? '' : name);
    emit(name);
  }

}
