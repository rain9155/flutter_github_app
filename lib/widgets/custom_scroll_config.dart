
import 'package:flutter/material.dart';

/// 可以为child应用自定义ScrollBehavior的ScrollConfiguration
class CustomScrollConfiguration extends StatelessWidget{

  const CustomScrollConfiguration({
    required this.child,
    this.behavior = const _DefaultScrollBehavior()
  });

  final Widget child;

  final ScrollBehavior behavior;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: behavior,
      child: child
    );
  }

}

class _DefaultScrollBehavior extends ScrollBehavior{

  const _DefaultScrollBehavior();

  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return child;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return GlowingOverscrollIndicator(
          child: child,
          axisDirection: axisDirection,
          color: Theme.of(context).accentColor,
          showLeading: false,//不显示头部波纹
          showTrailing: false,//不显示尾部波纹
        );
    }
  }
}