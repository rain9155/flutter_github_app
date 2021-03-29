
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/blocs/authentication_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/cubits/locale_cubit.dart';
import 'package:flutter_github_app/cubits/theme_cubit.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/main.dart';
import 'package:flutter_github_app/routes/webview_route.dart';
import 'package:flutter_github_app/utils/dialog_utIl.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';
import 'package:flutter_github_app/widgets/common_appbar.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/custom_divider.dart';
import 'package:flutter_github_app/widgets/custom_scroll_config.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsRoute extends StatelessWidget{

  static final name = 'SettingsRoute';

  static route(){
    return SettingsRoute._();
  }

  static Future push(BuildContext context){
    return Navigator.of(context).pushNamed(SettingsRoute.name);
  }

  SettingsRoute._();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      sliverHeaderBuilder: (context, _){
        return CommonSliverAppBar(
          title: CommonTitle(AppLocalizations.of(context).settings),
        );
      },
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
    return Builder(builder: (context){
      ThemeCubit themeCubit = BlocProvider.of<ThemeCubit>(context);
      LocaleCubit localeCubit = BlocProvider.of<LocaleCubit>(context);
      return CustomScrollView(
        slivers: [
          SliverFixedExtentList(
            itemExtent: 70,
            delegate: SliverChildListDelegate([
              ListTile(
                title: Text(AppLocalizations.of(context).cache),
                subtitle: Text(AppLocalizations.of(context).cacheNetRequest),
                trailing: FutureBuilder<bool>(
                  initialData: false,
                  future: SharedPreferencesUtil.getBool(KEY_ENABLE_CACHE, defaultValue: true),
                  builder: (context, snapshot){
                    bool value = snapshot.data;
                    return StatefulBuilder(
                      builder: (context, setState){
                        return Switch(
                          activeColor: Theme.of(context).accentColor,
                          value: value,
                          onChanged: (newValue){
                            setState((){
                              value = newValue;
                              SharedPreferencesUtil.setBool(KEY_ENABLE_CACHE, value);
                              AppConfig.enableCache = value;
                            });
                          }
                        );
                      }
                    );
                  },
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).theme),
                subtitle: Text(themeCubit.themeType == THEME_DART
                    ? AppLocalizations.of(context).dark
                    : AppLocalizations.of(context).light
                ),
                onTap: () => DialogUtil.showSimple(
                    context,
                    title: Text(AppLocalizations.of(context).theme),
                    options: [
                      SimpleDialogOption(
                        child: Text(AppLocalizations.of(context).light),
                        onPressed: (){
                          if(themeCubit.themeType != THEME_LIGHT){
                            themeCubit.setTheme(THEME_LIGHT);
                          }
                          DialogUtil.dismiss(context);
                        },
                      ),
                      SimpleDialogOption(
                        child: Text(AppLocalizations.of(context).dark),
                        onPressed: (){
                          if(themeCubit.themeType != THEME_DART){
                            themeCubit.setTheme(THEME_DART);
                          }
                          DialogUtil.dismiss(context);
                        },
                      )
                    ]
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).language),
                subtitle: Text(localeCubit.localeType == LAN_ENGLISH
                    ? 'English'
                    : '简体中文'
                ),
                onTap: () => DialogUtil.showSimple(
                    context,
                    title: Text(AppLocalizations.of(context).language),
                    options: [
                      SimpleDialogOption(
                        child: Text('简体中文'),
                        onPressed: (){
                          if(localeCubit.localeType != LAN_CHINESE){
                            localeCubit.setLocale(LAN_CHINESE);
                          }
                          DialogUtil.dismiss(context);
                        },
                      ),
                      SimpleDialogOption(
                          child: Text('English'),
                          onPressed: (){
                            if(localeCubit.localeType != LAN_ENGLISH){
                              localeCubit.setLocale(LAN_ENGLISH);
                            }
                            DialogUtil.dismiss(context);
                          }
                      )
                    ]
                ),
              ),
            ])
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: CustomDivider()
            )
          ),
          SliverFixedExtentList(
            itemExtent: 60,
            delegate: SliverChildListDelegate([
              ListTile(
                title: Text(AppLocalizations.of(context).feedback),
                onTap: () => launch('mailto:jianyu9155@gmail.com'),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).terms),
                onTap: () => WebViewRoute.push(
                  context,
                  url: '$URL_BASE_DOCS/${localeCubit.localeType == LAN_ENGLISH ? 'en' : 'cn'}/github/site-policy/github-terms-of-service',
                  title: AppLocalizations.of(context).terms
                )
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).privacy),
                onTap: () => WebViewRoute.push(
                  context,
                  url: '$URL_BASE_DOCS/${localeCubit.localeType == LAN_ENGLISH ? 'en' : 'cn'}/github/site-policy/github-privacy-statement',
                  title: AppLocalizations.of(context).privacy
                )
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).about),
                onTap: () => WebViewRoute.push(
                  context,
                  url: '$URL_BASE/about',
                  title: AppLocalizations.of(context).about
                )
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).logout),
                onTap: () => DialogUtil.showAlert(
                    context,
                    content: Text(AppLocalizations.of(context).logout),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(primary: Theme.of(context).accentColor),
                        child: Text(AppLocalizations.of(context).cancel),
                        onPressed: (){
                          DialogUtil.dismiss(context);
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(primary: Theme.of(context).accentColor),
                        child: Text(AppLocalizations.of(context).confirm),
                        onPressed: (){
                          BlocProvider.of<AuthenticationBloc>(context).add(LoggedOutEvent());
                          DialogUtil.dismiss(context);
                          Navigator.of(context).pop();
                        },
                      ),
                    ]
                ),
              ),
              FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      PackageInfo info = snapshot.data;
                      return Container(
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.center,
                        child: Text(
                          '${info.appName} for mobile ${info.version}',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Theme.of(context).disabledColor
                          ),
                        ),
                      );
                    }
                    return Container();
                  }
              ),
            ])
          ),
        ],
      );
    });
  }
}