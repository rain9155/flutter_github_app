
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/blocs/notification_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/mixin/load_more_sliverlist_mixin.dart';
import 'package:flutter_github_app/routes/all_route.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/date_util.dart';
import 'package:flutter_github_app/utils/dialog_utIl.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';
import 'package:flutter_github_app/utils/toast_util.dart';
import 'package:flutter_github_app/widgets/common_action.dart';
import 'package:flutter_github_app/widgets/common_issues_item.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/custom_divider.dart';
import 'package:flutter_github_app/widgets/empty_page_widget.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';
import 'package:flutter_github_app/beans/notification.dart' as Bean;

class NotificationPage extends StatefulWidget{

  static page(){
    return BlocProvider(
      create: (_) => NotificationBloc(),
      child: NotificationPage._(),
    );
  }

  NotificationPage._();

  @override
  _NotificationPageState createState() => _NotificationPageState();

}

class _NotificationPageState extends State<NotificationPage> with AutomaticKeepAliveClientMixin, LoadMoreSliverListMixin{

  bool _hasNotifications = false;

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(GetNotificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CommonScaffold(
      includeScaffold: false,
      sliverHeaderBuilder: (context, _){
        return _buildSliverAppBar(context);
      },
      body: _buildBody(),
      onRefresh: () => context.read<NotificationBloc>().refreshNotifications()
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return CommonSliverAppBar(
        title: CommonTitle(AppLocalizations.of(context).notifications),
        actions: [
          CommonAction(
            icon: Icons.more_vert_outlined,
            tooltip:  AppLocalizations.of(context).more,
            onPressed: (){
              if(!_hasNotifications){
                ToastUtil.showSnackBar(context, AppLocalizations.of(context).loading);
                return;
              }
              DialogUtil.showBottomSheet(
                context: context,
                routeSettings: RouteSettings(arguments: context.read<NotificationBloc>()),
                builder: (context){
                  bool showUnreadOnly = false;
                  // ignore: close_sinks
                  NotificationBloc notificationBloc = ModalRoute.of(context).settings.arguments as NotificationBloc;
                  return Container(
                      height: 60,
                      padding: EdgeInsets.all(15),
                      child: TightListTile(
                        leading: Text(AppLocalizations.of(context).showUnreadNotificationOnly),
                        trailing: FutureBuilder<bool>(
                            future: SharedPreferencesUtil.getBool(KEY_UNREAD),
                            builder: (context, snapshot) {
                              if(snapshot.connectionState == ConnectionState.done){
                                showUnreadOnly = snapshot.data;
                              }
                              return StatefulBuilder(
                                builder: (context, setState){
                                  return Switch(
                                    value: showUnreadOnly,
                                    onChanged: (bool newValue){
                                      setState(() {
                                        notificationBloc?.add(UnreadSwitchChangeEvent(newValue));
                                        notificationBloc?.add(GetNotificationsEvent());
                                        showUnreadOnly = newValue;
                                      });
                                    },
                                  );
                                },
                              );
                            }
                        ),
                      )
                    );
                  });
            }
          )
        ]
    );
  }

  Widget _buildBody() {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state){
        if(state is GettingNotificationState){
          return _buildBodyWithLoading(context);
        }
        if(state is GetNotificationFailureState){
          return _buildBodyWithFailure(context, state);
        }
        if(state is GetNotificationSuccessState){
          return _buildBodyWithSuccess(context, state);
        }
        return Container();
      },
    );
  }

  Widget _buildBodyWithLoading(BuildContext context){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildBodyWithFailure(BuildContext context, GetNotificationFailureState state){
    if(state.notifications == null){
      return TryAgainWidget(
        code: state.errorCode,
        onTryPressed: (){
          context.read<NotificationBloc>().add(GetNotificationsEvent());
        },
      );
    }
    return _buildSliverNotifications(context, state.notifications, state.hasMore);
  }

  Widget _buildBodyWithSuccess(BuildContext context, GetNotificationSuccessState state){
    return _buildSliverNotifications(context, state.notifications, state.hasMore);
  }

  Widget _buildSliverNotifications(BuildContext context, List<Bean.Notification> notifications, bool hasMore) {
    _hasNotifications = !CommonUtil.isListEmpty(notifications);
    if(!_hasNotifications){
      return SliverFillRemaining(
        child: EmptyPageWidget(AppLocalizations.of(context).noNotifications),
      );
    }
    return CustomScrollView(
      slivers: [
        buildSliverListWithFooter(
          context,
          itemCount: notifications.length,
          itemBuilder: (context, index){
            Bean.Notification notification = notifications[index];
            String type = notification.subject.type.toLowerCase();
            IconData leadingIcon;
            String htmlUrl;
            String title;
            if(type.contains('issue')){
              leadingIcon = Icons.error_outline_outlined;
              int number = int.tryParse(notification.subject.url.substring(notification.subject.url.lastIndexOf('/') + 1));
              title = "${notification.repository.fullName} #$number";
              htmlUrl = '$URL_BASE/${notification.repository.fullName}/issues/$number';
            }else if(type.contains('pullrequest')){
              leadingIcon = Icons.transform_outlined;
              int number = int.tryParse(notification.subject.url.substring(notification.subject.url.lastIndexOf('/') + 1));
              title = "${notification.repository.fullName} #$number";
              htmlUrl = '$URL_BASE/${notification.repository.fullName}/pull/$number';
            }else if(type.contains('alert')){
              leadingIcon = Icons.warning_amber_outlined;
              title = notification.repository.fullName;
              htmlUrl = '$URL_BASE/${notification.repository.fullName}';
            }else{
              leadingIcon = Icons.notifications_none_sharp;
              title = notification.repository.fullName;
              htmlUrl = '$URL_BASE/${notification.repository.fullName}';
            }
            return CommonIssuesItem(
              titleLeading: Icon(
                  leadingIcon,
                  color: Colors.grey[600]
              ),
              title: title,
              date: DateUtil.parseTime(context, notification.updatedAt),
              body: notification.subject.title,
              bodyTrailing: !notification.unread ? null : Icon(
                Icons.markunread,
                color: Theme.of(context).accentColor,
              ),
              onTap: () => WebViewRoute.push(
                context,
                url: htmlUrl,
              ),
            );
          },
          hasMore: hasMore,
          onLoadMore: () => context.read<NotificationBloc>().getMoreNotifications()
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
