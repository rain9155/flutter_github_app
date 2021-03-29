
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/cubits/theme_cubit.dart';

class CommonBodyText2 extends StatelessWidget{

  const CommonBodyText2(this.text, {
    this.color,
    this.maxLine = 1,
  });

  final String text;

  final Color color;

  final int maxLine;

  @override
  Widget build(BuildContext context) {
    var themeCubit = BlocProvider.of<ThemeCubit>(context);
    return Text(
      text?? '',
      maxLines: maxLine,
      style: Theme.of(context).textTheme.bodyText2.copyWith(
        color: color != null ? color : themeCubit.themeType == THEME_LIGHT ? Colors.grey[600] : Colors.grey
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}