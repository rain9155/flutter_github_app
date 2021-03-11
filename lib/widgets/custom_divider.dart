
import 'package:flutter/material.dart';

/// 没有padding的divider
class CustomDivider extends StatelessWidget{

  const CustomDivider({
    this.height = 0.5,
    this.color
  });

  final double height;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color ?? DividerTheme.of(context).color ?? Theme.of(context).dividerColor,
    );
  }

}