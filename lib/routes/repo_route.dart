
import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/widgets/rounded_image.dart';
import 'package:flutter_github_app/widgets/simple_chip.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class RepoRoute extends StatelessWidget{

  static const name = 'repoRoute';

  static Widget route(){
    return RepoRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pop();
          },
          tooltip: AppLocalizations.of(context).back,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: Theme.of(context).accentColor,
            ),
            onPressed: (){},
            tooltip: AppLocalizations.of(context).share,
          )
        ],
        elevation: 2,
      ),
      body: RefreshIndicator(
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  margin: EdgeInsets.only(top: 25),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      RoundedImage.asset(
                        PATH_DEFAULT_IMG,
                        width: 65,
                        height: 65,
                        radius: 8.0,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          'rain9155',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.grey
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'WanAndroid',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  margin: EdgeInsets.only(bottom: 5),
                  child: MarkdownBody(
                    data: ':muscle: WanAndroid应用，持续更新，不断打造成一款持续稳定, 功能完善的应用',
                    extensionSet: md.ExtensionSet.gitHubWeb,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Wrap(
                     children: [
                       SimpleChip(
                         avatar: Icon(
                           Icons.star_border_outlined,
                           color: Theme.of(context).disabledColor,
                         ),
                         label: Text('49 ${AppLocalizations.of(context).stars}'),
                         radius: 50,
                         onTap: (){},
                       ),
                       SizedBox(width: 10),
                       SimpleChip(
                         avatar: Icon(
                           Icons.alt_route_outlined,
                           color: Theme.of(context).disabledColor,
                         ),
                         label: Text('6 ${AppLocalizations.of(context).forks}'),
                         radius: 50,
                         onTap: (){},
                       ),
                     ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: OutlineButton(
                          child: SimpleChip(
                            avatar: Icon(
                              Icons.star_border_outlined,
                              color: Theme.of(context).accentColor,
                            ),
                            label: Text(
                              AppLocalizations.of(context).star.toUpperCase(),
                              style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).accentColor
                              ),
                            ),
                            gap: 6,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          highlightedBorderColor: Theme.of(context).dividerColor,
                          onPressed: (){}
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: OutlineButton(
                          child: SimpleChip(
                            avatar: Icon(
                              Icons.remove_red_eye_outlined,
                              color: Theme.of(context).accentColor,
                            ),
                            label: Text(
                              AppLocalizations.of(context).watch.toUpperCase(),
                              style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor
                              ),
                            ),
                            gap: 6,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          highlightedBorderColor: Theme.of(context).dividerColor,
                          onPressed: (){}
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Divider(),
                )
              ])
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                TightListTile(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  leading: Icon(
                      Icons.error,
                      color: Colors.green
                  ),
                  title: Text(AppLocalizations.of(context).issues),
                  trailing: Text(
                    '0',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.grey
                    ),
                  ),
                  onTap: (){},
                ),
                TightListTile(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  leading: Icon(
                    Icons.transform,
                    color: Colors.blue,
                  ),
                  title: Text(AppLocalizations.of(context).pullRequests),
                  trailing: Text(
                    '0',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.grey
                    ),
                  ),
                  onTap: (){},
                ),
                TightListTile(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  leading: Icon(
                    Icons.remove_red_eye,
                    color: Colors.orange,
                  ),
                  title: Text(AppLocalizations.of(context).watchers),
                  trailing: Text(
                    '2',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.grey
                    ),
                  ),
                  onTap: (){},
                ),
                TightListTile(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  leading: Icon(
                    Icons.insert_drive_file,
                    color: Colors.red,
                  ),
                  title: Text(AppLocalizations.of(context).license),
                  trailing: Text(
                    'Apache-2.0',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.grey
                    ),
                  ),
                  onTap: (){},
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Divider(),
                )
              ])
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                TightListTile(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  leading: Icon(
                    Icons.linear_scale,
                    color: Colors.grey,
                    size: 16,
                  ),
                  title: Text(
                    'master',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.grey
                    ),
                  ),
                  trailing: Text(
                    AppLocalizations.of(context).change.toUpperCase(),
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: Theme.of(context).accentColor
                    ),
                  ),
                  titlePadding: EdgeInsets.only(left: 10),
                  onTap: (){},
                ),
                TightListTile(
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  title: Text(AppLocalizations.of(context).browseCode),
                  onTap: (){},
                ),
                TightListTile(
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  title: Text(AppLocalizations.of(context).commits),
                  onTap: (){},
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Divider(),
                )
              ])
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                margin: EdgeInsets.symmetric(vertical: 15),
                child: MarkdownBody(
                  data: '# WanAndroid \n ### WanAndroid，一款基于MVP + Rxjava2 + Dagger2 + Retrofit + Material Design的应用, 欢迎大家start、fork。',
                  extensionSet: md.ExtensionSet.gitHubWeb,
                ),
              ),
            )
          ],
        ),
        onRefresh: (){
          return Future.delayed(Duration(seconds: 2));
        },
      ),
    );
  }


}