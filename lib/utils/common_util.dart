
import 'package:flutter/material.dart';

class CommonUtil{

  static Widget _buildSliver(Widget child){
    return SliverToBoxAdapter(
      child: child,
    );
  }

}