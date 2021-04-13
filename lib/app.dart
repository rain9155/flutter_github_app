import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/blocs/authentication_bloc.dart';
import 'package:flutter_github_app/cubits/locale_cubit.dart';
import 'package:flutter_github_app/cubits/theme_cubit.dart';
import 'package:flutter_github_app/cubits/user_cubit.dart';
import 'package:flutter_github_app/routes/search_route.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'routes/all_route.dart';

class MyApp extends StatelessWidget {

  static final tag = 'MyApp';

  static MultiBlocProvider route(){
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserCubit(),
        ),
        BlocProvider(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider(
          create: (_) => LocaleCubit(),
        ),
        BlocProvider(
          create: (context) => AuthenticationBloc(BlocProvider.of<UserCubit>(context)),
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
      locale: localeCubit.locale,
      localeListResolutionCallback: (locales, supportedLocales){
        debugPrint("localeListResolutionCallback: locales=$locales, supportedLocales=$supportedLocales");
        return localeCubit.locale;
      },
      /// 主题
      theme: themeCubit.theme,
      /// 路由表
      routes: {
        SplashRoute.name: (context) => SplashRoute.route(),
        LoginRoute.name: (context) => LoginRoute.route(),
        LoginWebViewRoute.name: (context) => LoginWebViewRoute.route(),
        MainRoute.name: (context) => MainRoute.route(),
        RepoRoute.name: (context) => RepoRoute.route(),
        SettingsRoute.name: (context) => SettingsRoute.route(),
        ReposRoute.name: (context) => ReposRoute.route(),
        OwnersRoute.name: (context) => OwnersRoute.route(),
        ProfileRoute.name: (context) => ProfileRoute.route(),
        BranchesRoute.name: (context) => BranchesRoute.route(),
        CommitsRoute.name: (context) => CommitsRoute.route(),
        WebViewRoute.name: (context) => WebViewRoute.route(),
        ContentsRoute.name: (context) => ContentsRoute.route(),
        ContentRoute.name: (context) => ContentRoute.route(),
        LicenseRoute.name: (context) => LicenseRoute.route(),
        IssuesRoute.name: (context) => IssuesRoute.route(),
        PullsRoute.name: (context) => PullsRoute.route(),
        SearchRoute.name: (context) => SearchRoute.route(),
        SearchesRoute.name: (context) => SearchesRoute.route(),
        CreateIssueRoute.name: (context) => CreateIssueRoute.route(),
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