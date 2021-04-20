import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/routes/pages/notification_page.dart';
import 'package:flutter_github_app/routes/pages/profile_page.dart';
import 'package:flutter_github_app/routes/pages/home_page.dart';
import 'package:flutter_github_app/utils/toast_util.dart';

class MainRoute extends StatefulWidget{

  static final name = 'MainRoute';

  static route(){
    return MainRoute._();
  }

  MainRoute._();

  @override
  _MainRouteState createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute>{

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
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation()
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
          child: PageView.builder(
            itemBuilder: (context, index){
              if(index < 1){
                return HomePage.page();
              }else if(index < 2){
                return NotificationPage.page();
              }else{
                return ProfilePage.page(PAGE_TYPE_PROFILE_USER);
              }
            },
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
          backgroundColor: Theme.of(context).primaryColor,
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