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
  String get home;
  String get explore;
  String get profile;
  String get search;
  String get share;
  String get settings;
  String get feedback;
  String get logout;

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

  @override
  String get home => '主页';

  @override
  String get explore => '探索';

  @override
  String get profile => '个人';

  @override
  String get search => '搜索';

  @override
  String get share => '分享';

  @override
  String get settings => '设置';

  @override
  String get feedback => '反馈';

  @override
  String get logout => '退出登陆';

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

  @override
  String get home => 'Home';

  @override
  String get explore => 'Explore';

  @override
  String get profile => 'Profile';

  @override
  String get search => 'Search';

  @override
  String get share => 'Share';

  @override
  String get settings => 'Settings';

  @override
  String get feedback => 'Feedback';

  @override
  String get logout => 'Logout';

}
