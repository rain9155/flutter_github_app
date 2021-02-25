import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/blocs/authentication_bloc.dart';
import 'package:flutter_github_app/cubits/locale_cubit.dart';
import 'package:flutter_github_app/cubits/theme_cubit.dart';
import 'package:flutter_github_app/routes/repo_route.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'routes/all_route.dart';

class MyApp extends StatelessWidget {

  static const tag = 'MyApp';

  static MultiBlocProvider route(){
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider(
          create: (_) => LocaleCubit(),
        ),
        BlocProvider(
          create: (_) => AuthenticationBloc(),
        )
      ],
      child: MyApp()
    );
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.printString(tag, 'build');
    var localeCubit = context.watch<LocaleCubit>();
    var themeCubit = context.watch<ThemeCubit>();
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
        if(localeCubit.locale != null){
          return locale;
        }
        //当前应用支持该系统切换的语言
        if(supportedLocales.contains(locale)){
          return locale;
        }
        //当前应用不支持该系统切换的语言，返回默认值
        return AppLocalizations.defaultLocale;
      },
      /// 主题
      theme: themeCubit.theme,
      /// 路由表
      routes: {
        SplashRoute.name: (context) => SplashRoute.route(),
        LoginRoute.name: (context) => LoginRoute.route(),
        WebViewRoute.name: (context) => WebViewRoute.route(),
        MainRoute.name: (context) => MainRoute.route(),
        RepoRoute.name: (context) => RepoRoute.route()
      },
      /// 应用主体
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state){
          if(state is AuthenticatedState){
            return MainRoute.route();
          }
          if(state is UnauthenticatedState){
            return LoginRoute.route();
          }
          return SplashRoute.route();
        },
      ),
    );
  }
}