part of 'app_localizations.dart';

/// app的所有字符串都定义在AppStrings中
abstract class _AppStrings{

  static Map<String, _AppStrings> _languageMap = {
    LAN_CHINESE : _ChineseStrings(),
    LAN_ENGLISH : _EnglishStrings()
  };

  static _AppStrings fromLocale(Locale locale){
    _AppStrings appStrings = _languageMap[locale.languageCode];
    if(appStrings == null){
      appStrings = _languageMap[AppLocalizations.defaultLocale.languageCode];
    }
    return appStrings;
  }

  String get appName;
  String get login;
  String get loginUnFinished;
  String get loginFail;

}

///AppStrings的zh实现
class _ChineseStrings extends _AppStrings{

  @override
  String get appName => 'GitHub';

  @override
  String get login => '登陆';

  @override
  String get loginUnFinished => '登陆未完成';

  @override
  String get loginFail => '登陆失败';

}

///AppStrings的en实现
class _EnglishStrings extends _AppStrings{

  @override
  String get appName => 'Github';

  @override
  String get login => 'Login';

  @override
  String get loginUnFinished => 'Login incomplete';

  @override
  String get loginFail => 'Login failed';

}
