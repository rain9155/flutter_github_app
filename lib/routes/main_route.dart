import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/blocs/authentication_bloc.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/routes/pages/notification_page.dart';
import 'package:flutter_github_app/routes/pages/profile_page.dart';
import 'package:flutter_github_app/utils/image_util.dart';
import 'package:flutter_github_app/routes/pages/home_page.dart';
import 'package:flutter_github_app/utils/toast_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainRoute extends StatefulWidget{

  static const tag = 'HomeRoute';
  static const name = 'homeRoute';

  static route(){
    return MainRoute();
  }

  @override
  _MainRouteState createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {

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
              tooltip: AppLocalizations.of(context).search,
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
    return Builder(
      builder: (context){
        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                      padding: EdgeInsets.zero,
                      child: Image.asset(
                        ImageUtil.getDefaultImgPath(),
                        fit: BoxFit.cover,
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
              )
          )
        );
      },
    );
  }

  static DateTime _lastDataTime;

  Widget _buildBody() {
    return Builder(
      builder: (context){
        return WillPopScope(
          onWillPop: () async{
            if(_lastDataTime == null || DateTime.now().difference(_lastDataTime) > Duration(seconds: 2)){
              _lastDataTime = DateTime.now();
              ToastUtil.showToast(AppLocalizations.of(context).exitAppTips);
              return false;
            }
            return true;
          },
          child: PageView(
            children: [
              HomePage(),
              NotificationPage(),
              ProfilePage()
            ],
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index){
              setState(() {
                _curIndex = index;
              });
            },
          ),
        );
      }
    );
  }

  Widget _buildBottomNavigation() {
    return Builder(
      builder: (context){
        return BottomNavigationBar(
          currentIndex: _curIndex,
          selectedItemColor: Theme.of(context).accentColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: AppLocalizations.of(context).home
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: AppLocalizations.of(context).notifications
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: AppLocalizations.of(context).profile
            )
          ],
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