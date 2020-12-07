import 'package:flutter/material.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/pages/splash_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        /// title
        onGenerateTitle: (context){
          return GlobalAppLocalizations.of(context).appName;
        },
        /// 多语言支持
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,//为Material组件库提供本地化的字符串
          GlobalWidgetsLocalizations.delegate,//为组件提供本地化的文本方向
          GlobalAppLocalizations.deglete//为当前应用提供本地化实现
        ],
        supportedLocales: GlobalAppLocalizations.supportedLocales,
        localeListResolutionCallback: (locales, supportedLocales){
          debugPrint("localeListResolutionCallback: locales=$locales, supportedLocales=$supportedLocales");
          return null;
        },
        localeResolutionCallback: (locale, supportedLocales){
          debugPrint("localeListResolutionCallback: locale=$locale, supportedLocales=$supportedLocales");
          for(Locale supportedLocale in supportedLocales){
            //当前应用支持该系统切换的语言
            if(locale == supportedLocale){
              return locale;
            }
          }
          //当前应用不支持该系统切换的语言，返回默认值
          return GlobalAppLocalizations.defaultLocale;
        },
        /// 主题
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        /// 路由表
        routes: {'':null},
        /// 应用主体
        home: SplashPage()
    );
  }
}


