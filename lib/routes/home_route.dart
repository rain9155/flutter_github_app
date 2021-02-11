import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/blocs/authentication_bloc.dart';
import 'package:flutter_github_app/cubits/theme_cubit.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/routes/all_route.dart';
import 'package:flutter_github_app/utils/image_util.dart';
import 'package:flutter_github_app/utils/log_util.dart';

class HomeRoute extends StatefulWidget{

  static const tag = 'HomeRoute';
  static const name = 'homeRoute';

  static route(){
    return HomeRoute();
  }

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {

  PageController _pageController;
  int _curIndex;

  @override
  void initState() {
    super.initState();
    _curIndex = 0;
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _buildSearchAction()
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation()
    );
  }

  Widget _buildSearchAction() {
    return Builder(
          builder: (context){
            return IconButton(
              icon: Icon(
                Icons.search,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: (){}
            );
          }
        );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Builder(
        builder: (context){
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  child: Image.asset(
                      ImageUtil.getBrandAssetsPath()
                  )
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text(AppLocalizations.of(context).share),
                onTap: (){},
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(AppLocalizations.of(context).settings),
                onTap: (){},
              ),
              Divider(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
              ListTile(
                leading: Icon(Icons.feedback),
                title: Text(AppLocalizations.of(context).feedback),
                onTap: (){},
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(AppLocalizations.of(context).logout),
                onTap: (){
                  context.read<AuthenticationBloc>().add(LoggedOutEvent());
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return PageView(
      children: [
        Center(
          child: Text('主页'),
        ),
        Center(
          child: Text('探索·'),
        ),
        Center(
          child: Text('个人'),
        ),
      ],
      controller: _pageController,
      onPageChanged: (index){
        setState(() {
          _curIndex = index;
        });
      },
    );
  }

  Widget _buildBottomNavigation() {
    return Builder(
      builder: (context){
        return BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: AppLocalizations.of(context).home
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: AppLocalizations.of(context).explore
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: AppLocalizations.of(context).profile
            )
          ],
          currentIndex: _curIndex,
          selectedItemColor: Theme.of(context).accentColor,
          onTap: (index){
            _curIndex = index;
            _pageController?.jumpToPage(index);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}