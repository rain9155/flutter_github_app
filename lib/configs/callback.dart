import 'package:flutter/cupertino.dart';

typedef CompleteCallback = Function();
typedef SuccessCallback = Function(dynamic data);
typedef ErrorCallback = Function(int code, String msg);
typedef LoadMoreCallback = Future<int> Function();
typedef NestedScrollViewHeaderSliverBuilder = Widget Function(BuildContext context, bool innerBoxIsScrolled);
typedef WidgetsBuilder = List<Widget> Function(BuildContext context);



