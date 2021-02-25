
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/routes/repo_route.dart';
import 'package:flutter_github_app/widgets/custom_scroll_config.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';

class HomePage extends StatelessWidget{

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
                      margin: EdgeInsets.only(bottom: 10, top: 25),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context).myWork,
                        style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    TightListTile(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      leading: Icon(
                          Icons.error,
                          color: Colors.green
                      ),
                      title: Text(AppLocalizations.of(context).issues),
                      onTap: (){

                      },
                    ),
                    TightListTile(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      leading: Icon(
                        Icons.transform,
                        color: Colors.blue,
                      ),
                      title: Text(AppLocalizations.of(context).pullRequests),
                      onTap: (){

                      },
                    ),
                    TightListTile(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      leading: Icon(
                        Icons.receipt,
                        color: Colors.purple,
                      ),
                      title: Text(AppLocalizations.of(context).repos),
                      onTap: (){
                        Navigator.of(context).pushNamed(RepoRoute.name);
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
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
                    AppLocalizations.of(context).myEvent,
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
