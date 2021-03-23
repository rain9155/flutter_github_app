
import 'package:flutter/material.dart';

/// 没有padding的divider
class CustomDivider extends StatelessWidget{

  const CustomDivider({
    this.bold = false,
    this.height,
    this.color
  });

  final double height;

  final Color color;

  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height?? (bold ? 1.35 : 0.35),
      color: color ?? DividerTheme.of(context).color ?? Theme.of(context).dividerColor,
    );
  }

}