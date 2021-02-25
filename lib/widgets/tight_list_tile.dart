
import 'package:flutter/material.dart';

/// leading、title间隔没那么大的ListTile
class TightListTile extends StatelessWidget{

  const TightListTile({
    this.leading,
    this.title,
    this.trailing,
    this.padding = EdgeInsets.zero,
    this.gap = 15,
    this.onTap
  });

  final Widget leading;

  final Widget title;

  final Widget trailing;

  final GestureTapCallback onTap;

  final EdgeInsetsGeometry padding;

  final double gap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            Expanded(
              child: Align(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    leading == null ? SizedBox() : leading,
                    SizedBox(width: title == null ? 0 : gap),
                    title == null ? SizedBox() : title
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
              flex: 1
            ),
            trailing == null ? SizedBox() : trailing,
          ],
        ),
      ),
    );
  }
}