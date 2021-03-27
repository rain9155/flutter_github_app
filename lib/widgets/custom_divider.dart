
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/cubits/theme_cubit.dart';

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
    var themeCubit = BlocProvider.of<ThemeCubit>(context);
    return Container(
      height: height?? (bold ? 1.35 : 0.35),
      color: color?? themeCubit.themeType == THEME_DART
          ? Colors.white.withOpacity(bold ? 0.02 : 0.22)
          : Theme.of(context).dividerColor,
    );
  }

}