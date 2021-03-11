part of 'app_localizations.dart';

/// app的所有字符串都定义在AppStrings中
abstract class _AppStrings{

  static Map<String, _AppStrings> _languageMap = {
    LAN_CHINESE : _ChineseStrings(),
    LAN_ENGLISH : _EnglishStrings()
  };

  static _AppStrings fromLocale(Locale locale){
    _AppStrings appStrings = _languageMap[locale.languageCode];
    if(appStrings == null){
      appStrings = _languageMap[AppLocalizations.defaultLocale.languageCode];
    }
    return appStrings;
  }

  String get appName;
  String get login;
  String get loginUnFinished;
  String get home;
  String get explore;
  String get profile;
  String get search;
  String get share;
  String get settings;
  String get feedback;
  String get logout;
  String get myWork;
  String get myEvent;
  String get issues;
  String get pullRequests;
  String get notifications;
  String get repos;
  String get trendingRepos;
  String get trendingDevelopers;
  String get exitAppTips;
  String get followers;
  String get following;
  String get pinned;
  String get myActivity;
  String get back;
  String get starred;
  String get stars;
  String get forks;
  String get star;
  String get watch;
  String get watched;
  String get watching;
  String get watchers;
  String get license;
  String get change;
  String get browseCode;
  String get commits;
  String get loadingMore;
  String get loadFail;
  String get loadComplete;
  String get just;
  String get hoursAgo;
  String get daysAgo;
  String get tryAgain;
  String get networkRequestError;
  String get networkConnectTimeout;
  String get networkConnectLost;
  String get networkRequestCancel;
  String get unknownError;
  String get tokenDenied;
  String get tokenExpire;
  String get tokenError;
  String get tokenScopeMissing;
  String get noNotifications;
  String get more;
  String get showUnreadNotificationOnly;

}

///AppStrings的zh实现
class _ChineseStrings extends _AppStrings{

  @override
  String get appName => 'GitHub';

  @override
  String get login => '登陆';

  @override
  String get loginUnFinished => '登陆未完成';

  @override
  String get home => '主页';

  @override
  String get explore => '探索';

  @override
  String get profile => '个人';

  @override
  String get search => '搜索';

  @override
  String get share => '分享';

  @override
  String get settings => '设置';

  @override
  String get feedback => '反馈';

  @override
  String get logout => '退出登陆';

  @override
  String get myEvent => '我的事件';

  @override
  String get myWork => '我的工作';

  @override
  String get issues => '问题';

  @override
  String get pullRequests => '拉取请求';

  @override
  String get repos => '仓库';

  @override
  String get notifications => '通知';

  @override
  String get trendingDevelopers => '热门开发者';

  @override
  String get trendingRepos => '热门仓库';

  @override
  String get exitAppTips => '再按一次退出应用';

  @override
  String get followers => '个关注者';

  @override
  String get following => '个关注';

  @override
  String get pinned => '已置顶';

  @override
  String get myActivity => '我的动态';

  @override
  String get back => '返回';

  @override
  String get starred => '已收藏';

  @override
  String get forks => '个复刻';

  @override
  String get stars => '个收藏';

  @override
  String get star => '收藏';

  @override
  String get watch => '关注';

  @override
  String get watching => '关注中';

  @override
  String get watchers => '关注者';

  @override
  String get license => '许可';

  @override
  String get change => '更改';

  @override
  String get browseCode => 'Browse Code';

  @override
  String get commits => 'Commits';

  @override
  String get loadingMore => '正在加载更多...';

  @override
  String get loadComplete => '已经到底了';

  @override
  String get loadFail => '加载失败';

  @override
  String get daysAgo => '天前';

  @override
  String get hoursAgo => '小时前';

  @override
  String get just => '刚刚';

  @override
  String get networkRequestError => '网络请求错误';

  @override
  String get tryAgain => '重试';

  @override
  String get networkConnectTimeout => '网络连接超时';

  @override
  String get unknownError => '未知错误';

  @override
  String get tokenDenied => '授权拒绝';

  @override
  String get tokenError => '授权错误';

  @override
  String get tokenExpire => '授权过期';

  @override
  String get tokenScopeMissing => '授权权限缺失';

  @override
  String get networkConnectLost => '没有网络连接';

  @override
  String get noNotifications => '没有任何通知';

  @override
  String get more => '更多';

  @override
  String get showUnreadNotificationOnly => '只显示未读通知';

  @override
  String get networkRequestCancel => '网络请求被取消';

  @override
  String get watched => '已关注';

}

///AppStrings的en实现
class _EnglishStrings extends _AppStrings{

  @override
  String get appName => 'Github';

  @override
  String get login => 'Login';

  @override
  String get loginUnFinished => 'Login Incomplete';

  @override
  String get home => 'Home';

  @override
  String get explore => 'Explore';

  @override
  String get profile => 'Profile';

  @override
  String get search => 'Search';

  @override
  String get share => 'Share';

  @override
  String get settings => 'Settings';

  @override
  String get feedback => 'Feedback';

  @override
  String get logout => 'Logout';

  @override
  String get myEvent => 'My Event';

  @override
  String get myWork => 'My Work';

  @override
  String get issues => 'Issues';

  @override
  String get pullRequests => 'Pull Requests';

  @override
  String get repos => 'Repositories';

  @override
  String get notifications => 'Notifications';

  @override
  String get trendingDevelopers => 'Trending Developers';

  @override
  String get trendingRepos => 'Trending Repositories';

  @override
  String get exitAppTips => 'Click again to exit the app';

  @override
  String get followers => 'followers';

  @override
  String get following => 'following';

  @override
  String get pinned => 'Pinned';

  @override
  String get myActivity => 'My Activity';

  @override
  String get back => 'Back';

  @override
  String get starred => 'Starred';

  @override
  String get forks => 'forks';

  @override
  String get stars => 'stars';

  @override
  String get star => 'Star';

  @override
  String get watch => 'Watch';

  @override
  String get watching => 'Watching';

  @override
  String get watchers => 'Watchers';

  @override
  String get license => 'License';

  @override
  String get change => 'change';

  @override
  String get browseCode => 'Browse Code';

  @override
  String get commits => "Commits";

  @override
  String get loadingMore => 'Loading More...';

  @override
  String get loadComplete => 'Load Complete';

  @override
  String get loadFail => 'Load Failed';

  @override
  String get daysAgo => ' days ago';

  @override
  String get hoursAgo => ' hours ago';

  @override
  String get just => 'just';

  @override
  String get networkRequestError => 'Network request error';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get networkConnectTimeout => 'Network connection timed out';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get tokenDenied => 'Token denied';

  @override
  String get tokenError => 'Token error';

  @override
  String get tokenExpire => 'Token expired';

  @override
  String get tokenScopeMissing => 'Token missing';

  @override
  String get networkConnectLost => 'Network connection lost';

  @override
  String get noNotifications => 'There are not any notifications';

  @override
  String get more => 'More';

  @override
  String get showUnreadNotificationOnly => 'Show unread notification only';

  @override
  String get networkRequestCancel => 'Network request cancelled';

  @override
  String get watched => 'Watched';

}
