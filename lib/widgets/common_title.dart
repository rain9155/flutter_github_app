
import 'package:flutter/material.dart';

class CommonTitle extends StatelessWidget{

  const CommonTitle(this.title, {
    this.style,
    this.titleDirection = TextDirection.ltr,
    this.titleOverflow = TextOverflow.ellipsis,
    this.titleAlign = TextAlign.left
  });

  final String? title;

  final TextStyle? style;

  final TextDirection titleDirection;

  final TextOverflow titleOverflow;

  final TextAlign titleAlign;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: title,
      ),
      style: style?? Theme.of(context).textTheme.headline6!.copyWith(
          fontWeight: FontWeight.bold
      ),
      textDirection: titleDirection,
      overflow: titleOverflow,
      textAlign: titleAlign,
    );
  }
}