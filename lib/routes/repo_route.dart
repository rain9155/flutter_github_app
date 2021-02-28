
import 'package:flutter/material.dart';
import 'package:flutter_github_app/cubits/theme_cubit.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/image_util.dart';
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
            icon: Icon(Icons.share),
            onPressed: (){

            },
            tooltip: AppLocalizations.of(context).share,
          )
        ],
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
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: AssetImage(ImageUtil.getDefaultImgPath())
                            )
                        ),
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
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                  onTap: (){},
                ),
                TightListTile(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  title: Text('Brow'),
                  onTap: (){},
                ),
              ])
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