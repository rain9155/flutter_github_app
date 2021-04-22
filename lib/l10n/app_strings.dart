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
  String get authUnFinished;
  String get deviceAuth;
  String get home;
  String get explore;
  String get profile;
  String get search;
  String get share;
  String get browser;
  String get settings;
  String get logout;
  String get myWork;
  String get myEvent;
  String get issues;
  String get pullRequests;
  String get notifications;
  String get repos;
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
  String get loadComplete;
  String get loadFail;
  String get just;
  String get hoursAgo;
  String get daysAgo;
  String get tryAgain;
  String get networkRequestError;
  String get networkConnectTimeout;
  String get networkConnectLost;
  String get networkRequestCancel;
  String get networkRequestLimitExceeded;
  String get networkRequestValidationFailed;
  String get featureTurnOff;
  String get unknownError;
  String get tokenDenied;
  String get tokenExpire;
  String get tokenError;
  String get tokenScopeMissing;
  String get noNotifications;
  String get more;
  String get showUnreadNotificationOnly;
  String get about;
  String get privacy;
  String get feedback;
  String get language;
  String get theme;
  String get terms;
  String get dark;
  String get light;
  String get cancel;
  String get confirm;
  String get refresh;
  String get clickTryAgain;
  String get noRepos;
  String get follower;
  String get follow;
  String get orgs;
  String get nothing;
  String get members;
  String get stargazers;
  String get fork;
  String get branches;
  String get defaultValue;
  String get cacheNetRequest;
  String get authored;
  String get loading;
  String get files;
  String get noFiles;
  String get created;
  String get assigned;
  String get mentioned;
  String get noIssues;
  String get open;
  String get closed;
  String get noPulls;
  String get recentSearches;
  String get clear;
  String get jumpTo;
  String reposWith(String text);
  String issuesWith(String text);
  String pullsWith(String text);
  String peopleWith(String text);
  String orgsWith(String text);
  String get searchHint;
  String get searchSubHint;
  String get noSearched;
  String get people;
  String seeReposWith(String count);
  String seeIssuesWith(String count);
  String seePullsWith(String count);
  String seePeopleWith(String count);
  String seeOrgsWith(String count);
  String get filter;
  String get inbox;
  String get createIssue;
  String get submit;
  String get issueHintTitle;
  String get issueHintBody;
  String get issueTitleEmpty;
  String get updateReadmeFail;
  String get expireTime;
  String hourWith(int count);

}

///AppStrings的zh实现
class _ChineseStrings extends _AppStrings{

  @override
  String get appName => 'GitHub';

  @override
  String get login => '登陆';

  @override
  String get authUnFinished => '授权未完成';

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
  String get feedback => '分享反馈';

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
  String get browseCode => '浏览代码';

  @override
  String get commits => '提交';

  @override
  String get loadingMore => '正在加载更多...';

  @override
  String get loadComplete => '已经到底了';

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
  String get noNotifications => '这里没有任何通知';

  @override
  String get more => '更多';

  @override
  String get showUnreadNotificationOnly => '只显示未读通知';

  @override
  String get networkRequestCancel => '网络请求被取消';

  @override
  String get watched => '已关注';

  @override
  String get about => '关于我们';

  @override
  String get language => '语言';

  @override
  String get privacy => '隐私策略';

  @override
  String get theme => '主题';

  @override
  String get terms => '服务条款';

  @override
  String get dark => '深色';

  @override
  String get light => '浅色';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确定';

  @override
  String get refresh => '刷新';

  @override
  String get clickTryAgain => '点击重试';

  @override
  String get browser => '在浏览器打开';

  @override
  String get noRepos => '这里没有任何仓库';

  @override
  String get follow => '关注';

  @override
  String get follower => '关注者';

  @override
  String get orgs => '组织';

  @override
  String get nothing => '这里没有任何内容';

  @override
  String get members => '成员';

  @override
  String get stargazers => '收藏者';

  @override
  String get fork => '复刻';

  @override
  String get branches => '分支';

  @override
  String get defaultValue => '默认值';

  @override
  String get cache => '缓存';

  @override
  String get cacheNetRequest => '缓存网络';

  @override
  String get authored => '撰写';

  @override
  String get loading => '加载中...';

  @override
  String get deviceAuth => '设备授权';

  @override
  String get files => '文件';

  @override
  String get noFiles => '这里没有任何文件';

  @override
  String get loadFail => '加载失败';

  @override
  String get assigned => '已分配';

  @override
  String get created => '已创建';

  @override
  String get mentioned => '已提及';

  @override
  String get noIssues => '这里没有任何问题';

  @override
  String get closed => '已关闭';

  @override
  String get open => '已激活';

  @override
  String get noPulls => '这里没有任何拉取请求';

  @override
  String get networkRequestLimitExceeded => '网络请求次数超过限制';

  @override
  String get networkRequestValidationFailed => '网络请求验证失败';

  @override
  String get recentSearches => '近期搜索';

  @override
  String get clear => '清除';

  @override
  String get jumpTo => '跳转到';

  @override
  String issuesWith(String text) => '包含 "$text" 的$issues';

  @override
  String orgsWith(text) => '包含 "$text" 的$orgs';

  @override
  String pullsWith(String text) => '包含 "$text" 的$pullRequests';

  @override
  String reposWith(String text) => '包含 "$text" 的$repos';

  @override
  String peopleWith(String text) => '包含 "$text" 的$people';

  @override
  String get searchHint => '查找你的内容';

  @override
  String get noSearched => '搜索不到任何东西';

  @override
  String get searchSubHint => '搜索所有Github中的$people、$repos、$orgs、$issues、和$pullRequests';

  @override
  String get people => '人员';

  @override
  String seeIssuesWith(String count) => '查看另外 $count 个$issues';

  @override
  String seeOrgsWith(String count) => '查看另外 $count 个$orgs';

  @override
  String seePeopleWith(String count) => '查看另外 $count 个$people';

  @override
  String seePullsWith(String count) => '查看另外 $count 个$pullRequests';

  @override
  String seeReposWith(String count) => '查看另外 $count 个$repos';

  @override
  String get filter => '过滤器';

  @override
  String get inbox => '收件箱';

  @override
  String get createIssue => '创建问题';

  @override
  String get submit => '提交';

  @override
  String get issueHintTitle => '标题';

  @override
  String get issueHintBody => '发表评论 (可选)';

  @override
  String get issueTitleEmpty => '标题不能为空';

  @override
  String get featureTurnOff => '该功能未打开';

  @override
  String get updateReadmeFail => '加载README失败';

  @override
  String get expireTime => '过期时间';

  @override
  String hourWith(int count) => '$count小时';

}

///AppStrings的en实现
class _EnglishStrings extends _AppStrings{

  @override
  String get appName => 'Github';

  @override
  String get login => 'Login in';

  @override
  String get authUnFinished => 'Auth unfinished';

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
  String get feedback => 'Share Feedback';

  @override
  String get logout => 'Login out';

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
  String get loadingMore => 'Loading more...';

  @override
  String get loadComplete => 'Load complete';

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

  @override
  String get about => 'About Us';

  @override
  String get language => 'Language';

  @override
  String get privacy => 'Privacy Policy';

  @override
  String get terms => 'Terms of Service';

  @override
  String get theme => 'Theme';

  @override
  String get dark => 'Dark';

  @override
  String get light => 'Light';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get refresh => 'Refresh';

  @override
  String get clickTryAgain => 'Click to try again';

  @override
  String get browser => 'Open in browser';

  @override
  String get noRepos => 'There are not any repos';

  @override
  String get follow => 'Following';

  @override
  String get follower => 'Followers';

  @override
  String get orgs => 'Organizations';

  @override
  String get nothing => 'Nothing to see here';

  @override
  String get members => 'Members';

  @override
  String get stargazers => 'Stargazers';

  @override
  String get fork => 'Forks';

  @override
  String get branches => 'Branches';

  @override
  String get defaultValue => 'default';

  @override
  String get cache => 'Cache';

  @override
  String get cacheNetRequest => 'Cache Network';

  @override
  String get authored => 'authored';

  @override
  String get loading => 'Loading...';

  @override
  String get deviceAuth => 'Device Authorization';

  @override
  String get files => 'Files';

  @override
  String get noFiles => 'There are not any files';

  @override
  String get loadFail => 'Failed to load';

  @override
  String get assigned => 'Assigned';

  @override
  String get created => 'Created';

  @override
  String get mentioned => 'Mentioned';

  @override
  String get noIssues => 'There are not any issues';

  @override
  String get closed => 'Closed';

  @override
  String get open => 'Open';

  @override
  String get noPulls => 'There are not any pull requests';

  @override
  String get networkRequestLimitExceeded => 'Network requests exceeded limit';

  @override
  String get networkRequestValidationFailed => 'Network request verification failed';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get clear => 'Clear';

  @override
  String get jumpTo => 'Jump to';

  @override
  String issuesWith(String text) => '$issues with $text';

  @override
  String orgsWith(text) => '$orgs with $text';

  @override
  String pullsWith(String text) => '$pullRequests with $text';

  @override
  String reposWith(String text) => '$repos with $text';

  @override
  String peopleWith(String text) => 'People with $text';

  @override
  String get searchHint => 'Find your stuff';

  @override
  String get noSearched => 'Can not find anything';

  @override
  String get searchSubHint => 'Search all of Github for $people, $repos, $orgs, $issues, and $pullRequests';

  @override
  String get people => 'People';

  @override
  String seeIssuesWith(String count) => 'See $count more $issues';

  @override
  String seeOrgsWith(String count) => 'See $count more $orgs';

  @override
  String seePeopleWith(String count) => 'See $count more $people';

  @override
  String seePullsWith(String count) => 'See $count more $pullRequests';

  @override
  String seeReposWith(String count) => 'See $count more $repos';

  @override
  String get filter => 'Filter';

  @override
  String get inbox => 'Inbox';

  @override
  String get createIssue => 'Create Issue';

  @override
  String get submit => 'Submit';

  @override
  String get issueHintTitle => 'Title';

  @override
  String get issueHintBody => 'Leave a comment (optional)';

  @override
  String get issueTitleEmpty => 'The title can not be blank';

  @override
  String get featureTurnOff => 'Feature is turned off';

  @override
  String get updateReadmeFail => 'Failed to load README';

  @override
  String get expireTime => 'Expire Time';

  @override
  String hourWith(int count) => '${count}h';
}
