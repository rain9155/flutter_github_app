
import 'package:flutter/material.dart';

class SimpleChip extends StatelessWidget{

  const SimpleChip({
    this.avatar,
    this.label,
    this.padding = EdgeInsets.zero,
    this.gap = 5,
    this.shape = BoxShape.circle,
    this.radius = 30,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.onTap
  });

  final Widget avatar;

  final Widget label;

  final EdgeInsets padding;

  final double gap;

  final BoxShape shape;

  final double radius;

  final BorderRadius borderRadius;

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
              label ?? SizedBox()
            ],
          ),
        ),
        highlightShape: shape,
        containedInkWell: shape == BoxShape.rectangle ? true : false,
        radius: radius,
        borderRadius: borderRadius,
        onTap: onTap,
      ),
    );
  }

}