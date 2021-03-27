
import 'package:flutter/material.dart';
import 'package:flutter_github_app/utils/common_util.dart';

/// 空页面提示widget
class EmptyPageWidget extends StatelessWidget{

  const EmptyPageWidget(this.hint, {
    this.subHint
  });

  final String hint;

  final String subHint;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            hint,
            style: Theme.of(context).textTheme.headline5.copyWith(
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if(!CommonUtil.isTextEmpty(subHint))
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              subHint,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}