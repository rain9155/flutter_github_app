
import 'package:flutter/material.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';

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

          ],
        ),
        onRefresh: (){
          return Future.delayed(Duration(seconds: 2));
        },
      ),
    );
  }


}