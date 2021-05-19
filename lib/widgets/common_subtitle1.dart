
import 'package:flutter/material.dart';

class CommonSubTitle1 extends StatelessWidget{

  const CommonSubTitle1(this.text, {
    this.color,
    this.bold = true,
    this.maxLine = 1
  });

  final String? text;

  final Color? color;

  final bool bold;

  final int maxLine;

  @override
  Widget build(BuildContext context) {
    return Text(
      text?? '',
      maxLines: maxLine,
      style: Theme.of(context).textTheme.subtitle1!.copyWith(
        color: color != null ? color : Theme.of(context).textTheme.subtitle1!.color,
        fontWeight: bold ? FontWeight.w600 : FontWeight.normal
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}