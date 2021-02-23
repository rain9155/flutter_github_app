
import 'package:flutter/material.dart';

/// leading、title间隔没那么大的ListTile
class TightListTile extends StatelessWidget{

  const TightListTile({
    this.leading,
    this.title,
    this.trailing,
    this.padding,
    this.onTap
  });

  final Widget leading;

  final Widget title;

  final Widget trailing;

  final GestureTapCallback onTap;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            leading == null ? Container() : Expanded(
              child: Align(
                child: leading,
                alignment: Alignment.centerLeft,
              ),
              flex: 1
            ),
            title == null ? Container() : Expanded(
              child: Align(
                child: title,
                alignment: Alignment.centerLeft,
              ),
              flex: 8
            ),
            trailing == null ? Container() : trailing,
          ],
        ),
      ),
    );
  }
}