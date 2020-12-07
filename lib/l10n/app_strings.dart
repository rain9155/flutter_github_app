part of 'app_localizations.dart';

/// app的所有字符串都定义在GlobalAppStrings中
abstract class _GlobalAppStrings{

  static Map<String, _GlobalAppStrings> _languageMap = {
    chinese : _ChineseStrings(),
    english : _EnglishStrings()
  };

  static _GlobalAppStrings fromLocale(Locale locale){
    _GlobalAppStrings globalAppStrings = _languageMap[locale.languageCode];
    if(globalAppStrings == null){
      globalAppStrings = _languageMap[GlobalAppLocalizations.defaultLocale.languageCode];
    }
    return globalAppStrings;
  }

  String get appName;

}

///GlobalAppStrings的zh实现
class _ChineseStrings extends _GlobalAppStrings{

  @override
  String get appName => 'GitHub应用';

}

///GlobalAppStrings的en实现
class _EnglishStrings extends _GlobalAppStrings{

  @override
  String get appName => 'GithubApp';

}
