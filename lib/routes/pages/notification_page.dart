
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
import 'package:flutter_github_app/utils/toast_util.dart';
import 'package:flutter_github_app/widgets/common_action.dart';
import 'package:flutter_github_app/widgets/common_issues_item.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/custom_divider.dart';
import 'package:flutter_github_app/widgets/custom_scroll_config.dart';
import 'package:flutter_github_app/widgets/empty_page_widget.dart';
import 'package:flutter_github_app/widgets/loading_widget.dart';
import 'package:flutter_github_app/widgets/pull_refresh_widget.dart';
import 'package:flutter_github_app/widgets/rounded_image.dart';
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

  bool? _hasNotifications;

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(GetNotificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollConfiguration(
      child: PullRefreshWidget(
        displacementIncrease: true,
        child: _buildBody(),
        onRefresh: () => context.read<NotificationBloc>().refreshNotifications(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state){
        if(state is GettingNotificationState){
          return _buildBodyWithLoading(context, state);
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

  Widget _buildBodyWithLoading(BuildContext context, GettingNotificationState state){
    return _buildBodyWithSliver(context, state.filterName, SliverFillRemaining(
      child: LoadingWidget(),
    ));
  }

  Widget _buildBodyWithFailure(BuildContext context, GetNotificationFailureState state){
    if(state.notifications == null){
      return _buildBodyWithSliver(context, state.filterName, SliverFillRemaining(
        child: TryAgainWidget(
          code: state.errorCode,
          onTryPressed: (){
            context.read<NotificationBloc>().add(GetNotificationsEvent());
          },
        ),
      ));
    }
    return _buildBodyWithSliver(context, state.filterName, _buildSliverNotifications(context, state.notifications, state.hasMore));
  }

  Widget _buildBodyWithSuccess(BuildContext context, GetNotificationSuccessState state){
    return _buildBodyWithSliver(context, state.filterName, _buildSliverNotifications(context, state.notifications, state.hasMore));
  }

  Widget _buildBodyWithSliver(BuildContext context, String? filterName, Widget sliver){
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        _buildSliverAppBar(context, filterName),
        sliver
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, String? filterName) {
    return CommonSliverAppBar(
      showLeading: false,
      title: CommonTitle(filterName?? AppLocalizations.of(context).inbox),
      actions: [
        CommonAction(
          icon: Icons.more_vert_outlined,
          tooltip:  AppLocalizations.of(context).more,
          onPressed: (){
            if(_hasNotifications == null){
              ToastUtil.showSnackBar(context, msg: AppLocalizations.of(context).loading);
              return;
            }
            double top = MediaQuery.of(context).padding.top;
            DialogUtil.showBottomSheet(
              context,
              isFullScreen: true,
              routeSettings: RouteSettings(arguments: context.read<NotificationBloc>()),
              builder: (context) => _buildFilterWidget(context, top),
            );
          }
        )
      ]
    );
  }

  Widget _buildFilterWidget(BuildContext context, double paddingTop){
    // ignore: close_sinks
    NotificationBloc notificationBloc = ModalRoute.of(context)!.settings.arguments as NotificationBloc;
    bool showUnreadOnly = !notificationBloc.all;
    return DraggableScrollableSheet(
      initialChildSize: 1.0,
      maxChildSize: 1.0,
      minChildSize: 0.5,
      builder: (context, controller){
        return Container(
          margin: EdgeInsets.only(top: paddingTop),
          child: Material(
            child: CustomScrollConfiguration(
              child: CustomScrollView(
                controller: controller,
                slivers: [
                  CommonSliverAppBar(
                    title: CommonTitle(AppLocalizations.of(context).filter),
                    backIcon: Icons.close,
                    titleSpacing: 0,
                    leadingWidth: 56,
                  ),
                  SliverList(delegate: SliverChildListDelegate([
                    TightListTile(
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      backgroundColor: Theme.of(context).primaryColor,
                      leading: Text(AppLocalizations.of(context).showUnreadNotificationOnly),
                      trailing: StatefulBuilder(
                        builder: (context, setState){
                          return Switch(
                            activeColor: Theme.of(context).accentColor,
                            value: showUnreadOnly,
                            onChanged: (bool newValue){
                              notificationBloc.add(UnreadSwitchChangeEvent(newValue));
                              setState(() => showUnreadOnly = newValue);
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: CustomDivider(bold: true),
                    ),
                    TightListTile(
                      padding: EdgeInsets.all(15),
                      titlePadding: EdgeInsets.only(left: 10),
                      backgroundColor: Theme.of(context).primaryColor,
                      leading: Icon(
                        Icons.inbox,
                        color: notificationBloc.filterName == null ? Theme.of(context).accentColor : null,
                      ),
                      title: Text(
                        AppLocalizations.of(context).inbox,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: notificationBloc.filterName == null ? Theme.of(context).accentColor : null
                        ),
                      ),
                      trailing: notificationBloc.filterName != null ? null : Icon(
                        Icons.check,
                        color: Theme.of(context).accentColor,
                      ),
                      onTap: (){
                        notificationBloc.add(FilterChangeEvent(null));
                        DialogUtil.dismiss(context);
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: CustomDivider(bold: true),
                    ),
                  ])),
                  SliverList(delegate: SliverChildBuilderDelegate((context, index){
                      NotificationOwner notificationOwner = notificationBloc.notificationOwners![index];
                      return TightListTile(
                        padding: EdgeInsets.all(15),
                        titlePadding: EdgeInsets.only(left: 10),
                        backgroundColor: Theme.of(context).primaryColor,
                        leading: RoundedImage.network(
                          notificationOwner.repoOwnerAvatarUrl!,
                          width: 30,
                          height: 30,
                          radius: 5,
                        ),
                        title: Text(
                          notificationOwner.repoName!,
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: notificationBloc.filterName == notificationOwner.repoName ? Theme.of(context).accentColor : null
                          ),
                        ),
                        trailing: notificationBloc.filterName != notificationOwner.repoName ? null : Icon(
                          Icons.check,
                          color: Theme.of(context).accentColor,
                        ),
                        onTap: (){
                          notificationBloc.add(FilterChangeEvent(notificationOwner.repoName));
                          DialogUtil.dismiss(context);
                        },
                      );
                    },
                    childCount: notificationBloc.notificationOwners!.length
                  )),
                  if(!CommonUtil.isListEmpty(notificationBloc.notificationOwners))
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: CustomDivider(bold: true),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliverNotifications(BuildContext context, List<Bean.Notification>? notifications, bool hasMore) {
    _hasNotifications = !CommonUtil.isListEmpty(notifications);
    if(!_hasNotifications!){
      return SliverFillRemaining(
        child: EmptyPageWidget(AppLocalizations.of(context).noNotifications),
      );
    }
    return buildSliverListWithFooter(
      context,
      itemCount: notifications!.length,
      itemBuilder: (context, index){
        Bean.Notification notification = notifications[index];
        String type = notification.subject!.type!.toLowerCase();
        IconData leadingIcon;
        String htmlUrl;
        String? title;
        if(type.contains('issue')){
          leadingIcon = Icons.error_outline_outlined;
          int? number = int.tryParse(notification.subject!.url!.substring(notification.subject!.url!.lastIndexOf('/') + 1));
          title = "${notification.repository!.fullName} #$number";
          htmlUrl = '$URL_BASE/${notification.repository!.fullName}/issues/$number';
        }else if(type.contains('pullrequest')){
          leadingIcon = Icons.transform_outlined;
          int? number = int.tryParse(notification.subject!.url!.substring(notification.subject!.url!.lastIndexOf('/') + 1));
          title = "${notification.repository!.fullName} #$number";
          htmlUrl = '$URL_BASE/${notification.repository!.fullName}/pull/$number';
        }else if(type.contains('alert')){
          leadingIcon = Icons.warning_amber_outlined;
          title = notification.repository!.fullName;
          htmlUrl = '$URL_BASE/${notification.repository!.fullName}';
        }else{
          leadingIcon = Icons.notifications_none_sharp;
          title = notification.repository!.fullName;
          htmlUrl = '$URL_BASE/${notification.repository!.fullName}';
        }
        return CommonIssuesItem(
          titleLeading: Icon(
              leadingIcon,
              color: Colors.grey[600]
          ),
          title: title,
          date: DateUtil.parseTime(context, notification.updatedAt!),
          body: notification.subject!.title,
          bodyTrailing: !notification.unread! ? null : Icon(
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
