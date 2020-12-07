import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_github_app/common/global_config.dart';

part 'app_strings.dart';

/// 多语言支持实现类，通过GlobalAppLocalizations的静态方法of获取GlobalAppStrings，再通过GlobalAppStrings获取文本字符串
class GlobalAppLocalizations{

  const GlobalAppLocalizations(this.locale);
  
  static const List<Locale> supportedLocales = [
    Locale('zh', 'CN'),//简体中文
    Locale('en', 'CN')//英语
  ];
  static Locale defaultLocale = supportedLocales[0];

  final Locale locale;

  static _GlobalAppStrings of(BuildContext context){
    GlobalAppLocalizations globalAppLocalizations = Localizations.of(context, GlobalAppLocalizations) as GlobalAppLocalizations;
    Locale locale = globalAppLocalizations.locale;
    return _GlobalAppStrings.fromLocale(locale);
  }

  static const _GlobalAppLocalizationsDeglete deglete = _GlobalAppLocalizationsDeglete();
}

/// GlobalAppLocalizations的工厂类
class _GlobalAppLocalizationsDeglete extends LocalizationsDelegate<GlobalAppLocalizations>{

  const _GlobalAppLocalizationsDeglete();

  @override
  bool isSupported(Locale locale) {
    debugPrint('isSupported: locale=$locale');
    return [chinese, english].contains(locale.languageCode);
  }

  /// 当isSupported返回true后，flutter会调用load方法根据新的Locale加载新的GlobalAppLocalizations
  @override
  Future<GlobalAppLocalizations> load(Locale locale) {
    debugPrint('load: locale=$locale');
    return SynchronousFuture<GlobalAppLocalizations>(GlobalAppLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<GlobalAppLocalizations> old) {
    return false;
  }
}