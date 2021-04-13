
import 'package:flutter/material.dart';
import 'package:flutter_github_app/widgets/custom_single_child_scroll_view.dart';

class LoadingWidget extends StatelessWidget{

  const LoadingWidget({
    this.isScroll = true
  });

  final bool isScroll;

  @override
  Widget build(BuildContext context) {
    Widget child = Center(child: CircularProgressIndicator());
    return !isScroll ? child : CustomSingleChildScrollView(child: child);
  }
}