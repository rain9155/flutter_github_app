import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/utils/log_util.dart';

part 'app_strings.dart';

/// 多语言支持实现类，通过AppLocalizations的静态方法of获取AppStrings，再通过AppStrings获取文本字符串
class AppLocalizations{

  const AppLocalizations(this.locale);

  final Locale locale;

  static const tag = 'AppLocalizations';
  static const List<Locale> supportedLocales = [
    Locale(LAN_CHINESE, 'CN'),//简体中文
    Locale(LAN_ENGLISH, 'CN')//英语
  ];
  static Locale defaultLocale = supportedLocales[0];
  static const _AppLocalizationsDeglete deglete = _AppLocalizationsDeglete();

  static _AppStrings of(BuildContext context){
    return _AppStrings.fromLocale(ofLocale(context));
  }

  static Locale ofLocale(BuildContext context){
    AppLocalizations appLocalizations = Localizations.of(context, AppLocalizations) as AppLocalizations;
    return appLocalizations.locale;
  }

}

/// AppLocalizations的工厂类
class _AppLocalizationsDeglete extends LocalizationsDelegate<AppLocalizations>{

  const _AppLocalizationsDeglete();

  @override
  bool isSupported(Locale locale) {
    LogUtil.printString(AppLocalizations.tag, 'isSupported: locale=$locale');
    return [LAN_CHINESE, LAN_ENGLISH].contains(locale.languageCode);
  }

  /// 当isSupported返回true后，flutter会调用load方法根据新的Locale加载新的AppLocalizations
  @override
  Future<AppLocalizations> load(Locale locale) {
    LogUtil.printString(AppLocalizations.tag, 'load: locale=$locale');
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}