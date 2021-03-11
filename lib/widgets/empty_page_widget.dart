
import 'package:flutter/material.dart';

/// 空页面提示widget
class EmptyPageWidget extends StatelessWidget{

  const EmptyPageWidget(this.hint);

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        hint,
        style: Theme.of(context).textTheme.headline5.copyWith(
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}