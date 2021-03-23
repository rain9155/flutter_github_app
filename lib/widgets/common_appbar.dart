import 'package:flutter/material.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';

class CommonAppBar extends AppBar{

  CommonAppBar({
    Widget title,
    List<Widget> actions,
    double titleSpacing,
    double elevation = 2,
    bool showLeading = true,
    double leadingWidth = 35,
  }) : super(
    title: title,
    actions: actions,
    elevation: elevation,
    leadingWidth: leadingWidth,
    titleSpacing: titleSpacing,
    leading: showLeading ? Builder(builder: (context){
      return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: AppLocalizations.of(context).back,
      );
    }) : null,
  );

}