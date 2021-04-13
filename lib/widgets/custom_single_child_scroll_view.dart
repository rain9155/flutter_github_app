
import 'package:flutter/material.dart';

class CustomSingleChildScrollView extends StatelessWidget{

  const CustomSingleChildScrollView({
    @required this.child,
    this.isIntrinsic = false
  });

  final Widget child;

  final bool isIntrinsic;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: !isIntrinsic ? child : IntrinsicHeight(child: child),
          ),
        );
      },
    );
  }
}