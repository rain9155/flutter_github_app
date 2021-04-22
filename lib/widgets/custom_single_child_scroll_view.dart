
import 'package:flutter/material.dart';

class CustomSingleChildScrollView extends StatelessWidget{

  const CustomSingleChildScrollView({
    @required this.child,
    this.isIntrinsic = false,
    this.physics,
    this.controller
  });

  final Widget child;

  final bool isIntrinsic;

  final ScrollPhysics physics;

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        return SingleChildScrollView(
          physics: physics,
          controller: controller,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: !isIntrinsic ? child : IntrinsicHeight(child: child),
          ),
        );
      },
    );
  }
}