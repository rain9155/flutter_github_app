
import 'package:flutter/material.dart';

/// 一个在水平方向放置两个child的Widget
class SimpleChip extends StatelessWidget{

  const SimpleChip({
    this.avatar,
    this.label,
    this.padding = EdgeInsets.zero,
    this.gap = 6,
    this.shape = BoxShape.circle,
    this.radius = 30,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.showSplash = true,
    this.onTap
  });

  final Widget avatar;

  final Widget label;

  final EdgeInsets padding;

  final double gap;

  final BoxShape shape;

  final double radius;

  final BorderRadius borderRadius;

  final bool showSplash;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkResponse(
        child: Container(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              avatar ?? SizedBox(),
              SizedBox(width: avatar != null && label != null ? gap : 0),
              Flexible(
                child: label ?? SizedBox(),
                fit: FlexFit.loose,
              )
            ],
          ),
        ),
        highlightShape: shape,
        containedInkWell: shape == BoxShape.rectangle ? true : false,
        radius: radius,
        borderRadius: borderRadius,
        highlightColor: showSplash ? null : Colors.transparent,
        splashColor: showSplash ? null : Colors.transparent,
        onTap: onTap,
      ),
    );
  }

}