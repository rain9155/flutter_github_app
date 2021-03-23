
import 'package:flutter/material.dart';

enum CrossAlignment {
  top,

  center,

  bottom
}


/// 可以自定义leading和title间隔的ListTile
class TightListTile extends StatelessWidget{

  const TightListTile({
    this.leading,
    this.title,
    this.trailing,
    this.padding = EdgeInsets.zero,
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 15),
    this.backgroundColor,
    this.height,
    this.crossAlignment = CrossAlignment.center,
    this.showSplash = true,
    this.onTap
  });

  final Widget leading;

  final Widget title;

  final Widget trailing;

  final GestureTapCallback onTap;

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry titlePadding;

  final Color backgroundColor;

  final double height;

  final bool showSplash;

  final CrossAlignment crossAlignment;

  @override
  Widget build(BuildContext context) {
    Alignment alignment;
    CrossAxisAlignment crossAxisAlignment;
    if(crossAlignment == CrossAlignment.top){
      alignment = Alignment.topLeft;
      crossAxisAlignment = CrossAxisAlignment.start;
    }else if(crossAlignment == CrossAlignment.center){
      alignment = Alignment.centerLeft;
      crossAxisAlignment = CrossAxisAlignment.center;
    }else{
      alignment = Alignment.bottomLeft;
      crossAxisAlignment = CrossAxisAlignment.end;
    }
    Widget child = Align(
      alignment: alignment,
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: crossAxisAlignment,
              children: [
                if(leading != null && title != null)
                  leading,
                if(leading != null && title == null)
                  Expanded(
                    child: leading,
                  ),
                if(title != null)
                  Expanded(
                    child: Padding(
                      padding: titlePadding,
                      child: title,
                    )
                  ),
                if(title == null)
                  Padding(
                    padding: titlePadding
                  )
              ],
            ),
          ),
          if(trailing != null) trailing
        ],
      ),
    );
    if(height != null){
      child = SizedBox(
        height: height,
        child: Padding(
          padding: padding,
          child: child,
        ),
      );
    }else{
      child = Padding(
        padding: padding,
        child: child,
      );
    }
    if(onTap != null){
      if(showSplash){
        child = InkWell(
          child: child,
          onTap: onTap,
        );
      }else{
        child = GestureDetector(
          child: child,
          onTap: onTap,
        );
      }
    }
    if(backgroundColor != null){
      child = Ink(
        color: backgroundColor,
        child: child,
      );
    }
    return child;
  }
}