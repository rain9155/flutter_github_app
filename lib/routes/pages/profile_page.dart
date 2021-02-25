
import 'package:flutter/material.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/image_util.dart';
import 'package:flutter_github_app/widgets/custom_scroll_config.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';

class ProfilePage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: CustomScrollConfiguration(
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
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(ImageUtil.getDefaultImgPath())
                            )
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mr.Chen",
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                'rain9155',
                                style: Theme.of(context).textTheme.subtitle1.copyWith(
                                  color: Colors.grey
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'Android developer',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TightListTile(
                      leading: Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: Theme.of(context).disabledColor,
                      ),
                      title: Text(
                        'GuangZhou-GuangDong-China',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      gap: 6,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    margin: EdgeInsets.only(top: 10),
                    child: TightListTile(
                      leading: Icon(
                        Icons.link_outlined,
                        size: 20,
                        color: Theme.of(context).disabledColor,
                      ),
                      title: Text(
                        'https://rain9155.github.io',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      gap: 6,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    margin: EdgeInsets.only(top: 6),
                    child: TightListTile(
                      leading: Icon(
                        Icons.person_outline_outlined,
                        size: 20,
                        color: Theme.of(context).disabledColor,
                      ),
                      title: Row(
                        children: [
                          Text(
                            '13 ${AppLocalizations.of(context).followers}',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              '·',
                              style: Theme.of(context).textTheme.subtitle2.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 25
                              ),
                            )
                          ),
                          Text(
                            '7 ${AppLocalizations.of(context).following}',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                      gap: 6,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Divider(),
                  )
                ])
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 15),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.push_pin_outlined,
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Text(
                          AppLocalizations.of(context).pinned,
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 150,
                    child: ListView.separated(
                        itemCount: 5,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index){
                          return SizedBox(width: 10);
                        },
                        itemBuilder: (context, index){
                          return InkWell(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 250,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(context).dividerColor),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Text(index.toString()),
                            ),
                            onTap: (){

                            },
                          );
                        }
                    ),
                  ),
                  SizedBox(height: 15),
                  TightListTile(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    leading: Icon(
                      Icons.receipt,
                      color: Colors.purple,
                    ),
                    title: Text(AppLocalizations.of(context).repos),
                    trailing: Text(
                      '39',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.grey
                      ),
                    ),
                    onTap: (){

                    },
                  ),
                  TightListTile(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    leading: Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    title: Text(AppLocalizations.of(context).stars),
                    trailing: Text(
                      '180',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.grey
                      ),
                    ),
                    onTap: (){

                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    child: Divider(),
                  )
                ])
              ),
              SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context).myActivity,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w600),
                    ),
                  )
              ),
              SliverFixedExtentList(
                  itemExtent: 80,
                  delegate: SliverChildBuilderDelegate((context, index){
                    return InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerLeft,
                        child: Text("$index"),
                      ),
                      onTap: (){

                      },
                    );
                  })
              )
            ],
          ),
        ),
        onRefresh: (){
          return Future.delayed(Duration(seconds: 2));
        }
    );
  }

}