
import 'package:flutter/cupertino.dart';
import 'package:flutter_github_app/models/locale_model.dart';
import 'package:flutter_github_app/models/theme_model.dart';
import 'package:flutter_github_app/models/user_model.dart';
import 'package:provider/provider.dart';

class ProviderUtil{

  static MultiProvider getApp(Widget child){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleModel(),
        )
      ],
      child: child,
    );
  }

}