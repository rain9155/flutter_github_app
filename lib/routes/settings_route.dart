import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/blocs/authentication_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/cubits/locale_cubit.dart';
import 'package:flutter_github_app/cubits/theme_cubit.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/routes/all_route.dart';
import 'package:flutter_github_app/routes/webview_route.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/dialog_utIl.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/custom_divider.dart';
import 'package:flutter_github_app/widgets/rebuild_app_widget.dart';
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
              FutureBuilder<List>(
                initialData: [false, 1],
                future: Future.wait([
                  SharedPreferencesUtil.getBool(KEY_ENABLE_CACHE, defaultValue: true),
                  SharedPreferencesUtil.getInt(KEY_EXPIRE_TIME, defaultValue: 24)
                ]),
                builder: (context, snapshot){
                  bool enableCache = snapshot.data[0];
                  int expireTime = snapshot.data[1];
                  return StatefulBuilder(builder: (context, setState){
                    return ListTile(
                      title: Text(AppLocalizations.of(context).cacheNetRequest),
                      subtitle: Text(AppLocalizations.of(context).hourWith(expireTime)),
                      trailing: Switch(
                        activeColor: Theme.of(context).accentColor,
                        value: enableCache,
                        onChanged: (newValue) => setState((){
                          enableCache = newValue;
                          SharedPreferencesUtil.setBool(KEY_ENABLE_CACHE, enableCache);
                        })
                      ),
                      onTap: !enableCache ? null : () async{
                        bool changeTime = await DialogUtil.showAlert(
                          context,
                          contextPadding: const EdgeInsets.only(top: 15, right: 15),
                          titleBuilder: (context) => Text(AppLocalizations.of(context).expireTime),
                          contentBuilder: (context) => SliderTheme(
                            data: Theme.of(context).sliderTheme.copyWith(
                              activeTrackColor: Theme.of(context).accentColor,
                              inactiveTrackColor: Theme.of(context).dividerColor,
                              thumbColor: Theme.of(context).accentColor,
                              activeTickMarkColor: Colors.transparent,
                              inactiveTickMarkColor: Colors.transparent,
                              overlayColor: Theme.of(context).accentColor.withOpacity(0.12),
                              showValueIndicator: ShowValueIndicator.never
                            ),
                            child: StatefulBuilder(builder: (context, setState){
                              return Container(
                                height: 35,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Slider(
                                        min: 1,
                                        max: 24,
                                        value: expireTime.toDouble(),
                                        onChanged: (value) => setState(() => expireTime = value.round())
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(minWidth: 35),
                                      child: Text(AppLocalizations.of(context).hourWith(expireTime)),
                                    )
                                  ],
                                ),
                              );
                            }),
                          ),
                          actionsBuilder: (context) => [
                            TextButton(
                              style: TextButton.styleFrom(primary: Theme.of(context).accentColor),
                              child: Text(AppLocalizations.of(context).cancel),
                              onPressed: () => DialogUtil.dismiss(context),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(primary: Theme.of(context).accentColor),
                              child: Text(AppLocalizations.of(context).confirm),
                              onPressed: (){
                                if(expireTime != null){
                                  SharedPreferencesUtil.setInt(KEY_EXPIRE_TIME, expireTime);
                                }
                                DialogUtil.dismiss(context, result: expireTime != null);
                              },
                            ),
                          ]
                        );
                        if(changeTime){
                          setState((){});
                        }
                      }
                    );
                  });
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).theme),
                subtitle: Text(themeCubit.themeMode == ThemeMode.light
                  ? AppLocalizations.of(context).light
                  : themeCubit.themeMode == ThemeMode.dark
                    ? AppLocalizations.of(context).dark
                    : AppLocalizations.of(context).system
                ),
                onTap: () async{
                  await DialogUtil.showSimple(
                    context,
                    titleBuilder: (context) => Text(AppLocalizations.of(context).theme),
                    childrenBuilder: (context) => [
                      SimpleDialogOption(
                        child: Text(AppLocalizations.of(context).light),
                        onPressed: (){
                          if(themeCubit.setThemeMode(ThemeMode.light)){
                            Future.delayed(Duration(microseconds: 500), () => CommonUtil.setSystemUIColor(false));
                          }
                          DialogUtil.dismiss(context);
                        },
                      ),
                      SimpleDialogOption(
                        child: Text(AppLocalizations.of(context).dark),
                        onPressed: (){
                          if(themeCubit.setThemeMode(ThemeMode.dark)){
                            Future.delayed(Duration(microseconds: 500), () => CommonUtil.setSystemUIColor(true));
                          }
                          DialogUtil.dismiss(context);
                        },
                      ),
                      SimpleDialogOption(
                        child: Text(AppLocalizations.of(context).system),
                        onPressed: (){
                          themeCubit.setThemeMode(ThemeMode.system);
                          DialogUtil.dismiss(context);
                        },
                      )
                    ]
                  );
                  if(themeCubit.themeMode == ThemeMode.system){
                    Future.delayed(Duration(seconds: 1), () => CommonUtil.setSystemUIColor(CommonUtil.isDarkMode(context)));
                  }
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).language),
                subtitle: Text(localeCubit.localeMode == LocaleMode.chinese
                    ? '简体中文'
                    : localeCubit.localeMode == LocaleMode.english
                      ? 'English'
                      : AppLocalizations.of(context).system
                ),
                onTap: () => DialogUtil.showSimple(
                  context,
                  titleBuilder: (context) => Text(AppLocalizations.of(context).language),
                  childrenBuilder: (context) => [
                    SimpleDialogOption(
                      child: Text('简体中文'),
                      onPressed: (){
                        localeCubit.setLocaleMode(LocaleMode.chinese);
                        DialogUtil.dismiss(context);
                      },
                    ),
                    SimpleDialogOption(
                      child: Text('English'),
                      onPressed: (){
                        localeCubit.setLocaleMode(LocaleMode.english);
                        DialogUtil.dismiss(context);
                      }
                    ),
                    SimpleDialogOption(
                      child: Text(AppLocalizations.of(context).system),
                      onPressed: (){
                        if(localeCubit.setLocaleMode(LocaleMode.system)){
                          RebuildAppWidget.rebuild(context);
                        }
                        DialogUtil.dismiss(context);
                      }
                    ),
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
                  url: '$URL_BASE_DOCS/${CommonUtil.isEnglishMode(context) ? 'en' : 'cn'}/github/site-policy/github-terms-of-service',
                  title: AppLocalizations.of(context).terms
                )
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).privacy),
                onTap: () => WebViewRoute.push(
                  context,
                  url: '$URL_BASE_DOCS/${CommonUtil.isEnglishMode(context) ? 'en' : 'cn'}/github/site-policy/github-privacy-statement',
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
                  contentBuilder: (context) => Text(AppLocalizations.of(context).logout),
                  actionsBuilder: (context) => [
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