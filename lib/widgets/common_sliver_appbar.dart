
import 'package:flutter/material.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';

class CommonSliverAppBar extends SliverAppBar{

  CommonSliverAppBar({
    Widget title,
    List<Widget> actions,
    double titleSpacing,
    bool pinned = true,
    double elevation = 2,
    double leadingWidth = 35,
    bool showLeading = true,
    bool forceElevated = false,
    PreferredSizeWidget bottom,
    IconData backIcon,
    this.onBack
  }) : super(
    title: title,
    actions: actions,
    pinned: pinned,
    elevation: elevation,
    leadingWidth: leadingWidth,
    titleSpacing: titleSpacing,
    leading: showLeading ? Builder(builder: (context){
      return IconButton(
        icon: Icon(backIcon?? Icons.arrow_back),
        tooltip: AppLocalizations.of(context).back,
        onPressed: () async{
          if(onBack == null || await onBack.call()){
            Navigator.of(context).pop();
          }
        },
      );
    }) : null,
    forceElevated: forceElevated,
    bottom: bottom
  );

  final WillPopCallback onBack;
}