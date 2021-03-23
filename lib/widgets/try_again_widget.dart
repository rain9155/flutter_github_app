
import 'package:flutter/material.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/common_util.dart';

/// 错误重试widget
class TryAgainWidget extends StatelessWidget{

  const TryAgainWidget({
    this.hint,
    this.code,
    this.backgroundColor,
    this.onTryPressed,
  });

  final int code;

  final String hint;

  final Color backgroundColor;

  final VoidCallback onTryPressed;

  @override
  Widget build(BuildContext context) {
    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          code != null ? CommonUtil.getErrorMsgByCode(context, code) : hint?? '',
          style: Theme.of(context).textTheme.headline5.copyWith(
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              onPrimary: Theme.of(context).accentColor,
              padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
          ),
          child: Text(AppLocalizations.of(context).tryAgain),
          onPressed: onTryPressed,
        ),
      ],
    );
    if(backgroundColor != null){
      child = Container(
        color: backgroundColor,
        child: child,
      );
    }
    return child;
  }

}