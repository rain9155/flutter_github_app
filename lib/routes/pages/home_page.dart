
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/widgets/custom_scroll_config.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';

class HomePage extends StatefulWidget{

  @override
  State createState() => _HomePageState();

}

class _HomePageState extends State<HomePage>{

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: CustomScrollConfiguration(
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildSliver(Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context).myWork,
                style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w600),
              ),
            )),
            SliverFixedExtentList(
                itemExtent: 50,
                delegate: SliverChildListDelegate([
                  TightListTile(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    leading: Icon(
                        Icons.error,
                        color: Colors.green
                    ),
                    title: Text(AppLocalizations.of(context).issues),
                    onTap: (){

                    },
                  ),
                  TightListTile(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    leading: Icon(
                      Icons.transform,
                      color: Colors.blue,
                    ),
                    title: Text(AppLocalizations.of(context).pullRequests),
                    onTap: (){

                    },
                  ),
                  TightListTile(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    leading: Icon(
                      Icons.receipt,
                      color: Colors.purple,
                    ),
                    title: Text(AppLocalizations.of(context).repos),
                    onTap: (){

                    },
                  ),
                ])
            ),
            _buildSliver(Divider()),
            _buildSliver(Container(
              margin: EdgeInsets.only(top: 6),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context).myEvent,
                style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w600),
              ),
            )),
            SliverFixedExtentList(
              itemExtent: 80,
              delegate: SliverChildBuilderDelegate(
                (context, index){
                  return InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      child: Text("$index"),
                    ),
                    onTap: (){

                    },
                  );
                },
              )
            )
          ],
        ),
      ),
      onRefresh: (){
        return Future.delayed(Duration(seconds: 2));
      }
    );
  }

  Widget _buildSliver(Widget child){
    return SliverToBoxAdapter(
      child: child,
    );
  }
}