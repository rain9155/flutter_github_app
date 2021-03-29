
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/cubits/theme_cubit.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/widgets/common_bodytext2.dart';
import 'package:flutter_github_app/widgets/rounded_image.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';

class CommonEventsItem extends StatelessWidget{

  const CommonEventsItem({
    this.actorAvatarUrl,
    this.action,
    this.date,
    this.onTap
  });

  final String actorAvatarUrl;

  final String action;

  final String date;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TightListTile(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 80,
      backgroundColor: Theme.of(context).primaryColor,
      titlePadding: CommonUtil.isTextEmpty(actorAvatarUrl) ? EdgeInsets.only(right: 15) : EdgeInsets.symmetric(horizontal: 15),
      leading: CommonUtil.isTextEmpty(actorAvatarUrl) ? null : RoundedImage.network(
        actorAvatarUrl,
        width: 40,
        height: 40,
        radius: 5.0,
      ),
      title: CommonBodyText2(
        action,
        maxLine: 3,
        color: Theme.of(context).textTheme.bodyText2.color,
      ),
      trailing: CommonBodyText2(date),
      onTap: onTap,
    );
  }
}