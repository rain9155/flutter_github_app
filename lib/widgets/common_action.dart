
import 'package:flutter/material.dart';

class CommonAction extends StatelessWidget{

  const CommonAction({
    @required this.icon,
    this.tooltip,
    this.onPressed
  });

  final IconData icon;

  final String tooltip;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(
        icon,
        color: Theme.of(context).accentColor,
      ),
      onPressed: onPressed,
    );
  }
}