import 'package:flutter/material.dart';
import 'package:flutter_github_app/routes/home_route.dart';
import 'package:flutter_github_app/routes/login_route.dart';
import 'package:flutter_github_app/routes/splash_route.dart';
import 'package:flutter_github_app/routes/webview_route.dart';
import 'package:flutter_github_app/utils/provider_util.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'models/locale_model.dart';
import 'models/theme_model.dart';

void main() {
  runApp(ProviderUtil.getApp(MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    debugPrint('MyApp build');
    var localeModel = Provider.of<LocaleModel>(context);
    var themeModel = Provider.of<ThemeModel>(context);
    return MaterialApp(
        /// title
        onGenerateTitle: (context){
          return AppLocalizations.of(context).appName;
        },
        /// 多语言支持
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,//为Material组件库提供本地化的字符串
          GlobalWidgetsLocalizations.delegate,//为组件提供本地化的文本方向
          AppLocalizations.deglete//为当前应用提供本地化实现
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        localeListResolutionCallback: (locales, supportedLocales){
          debugPrint("localeListResolutionCallback: locales=$locales, supportedLocales=$supportedLocales");
          return null;
        },
        localeResolutionCallback: (locale, supportedLocales){
          debugPrint("localeListResolutionCallback: locale=$locale, supportedLocales=$supportedLocales");
          //如果用户指定了，直接返回
          if(localeModel.getLocale() != null){
            return localeModel.getLocale();
          }
          //当前应用支持该系统切换的语言
          if(supportedLocales.contains(locale)){
            return locale;
          }
          //当前应用不支持该系统切换的语言，返回默认值
          return AppLocalizations.defaultLocale;
        },
        /// 主题
        theme: themeModel.getTheme(),
        /// 路由表
        routes: {
          SplashRoute.name: (context) => SplashRoute(),
          LoginRoute.name: (context) => LoginRoute(),
          WebViewRoute.name: (context) => WebViewRoute(),
          HomeRoute.name: (context) => HomeRoute()
        },
        initialRoute: SplashRoute.name,
    );
  }
}


