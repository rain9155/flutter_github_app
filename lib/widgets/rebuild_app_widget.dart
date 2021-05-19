
import 'package:flutter/material.dart';

/// 重新生成key导致child重新build
class RebuildAppWidget extends StatefulWidget{

  const RebuildAppWidget({
    required this.child
  });

  final Widget child;

  static rebuild(BuildContext context){
    context.findAncestorStateOfType<_RebuildAppWidgetState>()?.updateKey();
  }

  @override
  _RebuildAppWidgetState createState() => _RebuildAppWidgetState();
}

class _RebuildAppWidgetState extends State<RebuildAppWidget> {

  Key _key = UniqueKey();

  updateKey() => setState(() => _key = UniqueKey());

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}