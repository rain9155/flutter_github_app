
import 'package:flutter/material.dart';
import 'package:flutter_github_app/utils/common_util.dart';

class CommonBodyText2 extends StatelessWidget{

  const CommonBodyText2(this.text, {
    this.color,
    this.maxLine = 1,
  });

  final String? text;

  final Color? color;

  final int maxLine;

  @override
  Widget build(BuildContext context) {
    return Text(
      text?? '',
      maxLines: maxLine,
      style: Theme.of(context).textTheme.bodyText2!.copyWith(
        color: color != null ? color : !CommonUtil.isDarkMode(context) ? Colors.grey[600] : Colors.grey
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}