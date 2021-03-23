
import 'package:flutter/material.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';

class CommonTitle extends StatelessWidget{

  const CommonTitle(this.title, {
    this.style,
    this.titleDirection = TextDirection.ltr,
    this.titleOverflow = TextOverflow.ellipsis
  });

  final String title;

  final TextStyle style;

  final TextDirection titleDirection;

  final TextOverflow titleOverflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: style?? Theme.of(context).textTheme.headline6.copyWith(
          fontWeight: FontWeight.bold
      ),
      textDirection: titleDirection,
      overflow: titleOverflow,
    );
  }
}