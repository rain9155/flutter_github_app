
import 'package:flutter/material.dart';

class PullRefreshWidget extends StatelessWidget{

  const PullRefreshWidget({
    this.key,
    required this.child,
    required this.onRefresh,
    this.displacementIncrease = false,
    this.notificationPredicate = defaultScrollNotificationPredicate
  });

  final Key? key;

  final Widget child;

  final RefreshCallback? onRefresh;

  final bool displacementIncrease;

  final ScrollNotificationPredicate notificationPredicate;

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double appBarHeight = kToolbarHeight;
    return RefreshIndicator(
      key: key,
      child: child,
      onRefresh: onRefresh!,
      displacement: displacementIncrease ? (40 + appBarHeight + statusBarHeight) : 40,
      notificationPredicate: notificationPredicate,
      color: Colors.white,
      backgroundColor: Theme.of(context).accentColor,
    );
  }
}