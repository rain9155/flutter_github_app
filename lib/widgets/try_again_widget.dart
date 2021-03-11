
import 'package:flutter/material.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';

/// 错误重试widget
class TryAgainWidget extends StatelessWidget{

  const TryAgainWidget({
    @required this.hint,
    this.onTryPressed
  });

  final String hint;

  final VoidCallback onTryPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hint,
            style: Theme.of(context).textTheme.headline5.copyWith(
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10),
          RaisedButton(
            child: Text(AppLocalizations.of(context).tryAgain),
            color: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            highlightColor: Colors.transparent,
            disabledColor: Theme.of(context).primaryColor,
            textColor: Theme.of(context).accentColor,
            onPressed: onTryPressed,
          ),
        ],
      ),
    );
  }

}