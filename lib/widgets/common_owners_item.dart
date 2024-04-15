
import 'package:flutter/material.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/widgets/common_bodytext2.dart';
import 'package:flutter_github_app/widgets/common_subtitle1.dart';
import 'package:flutter_github_app/widgets/rounded_image.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';

class CommonOwnersItem extends StatelessWidget{

  const CommonOwnersItem({
    this.ownerAvatarUrl,
    this.ownerLoginName,
    this.ownerDescription,
    this.onTap
  });

  final String? ownerAvatarUrl;

  final String? ownerLoginName;

  final String? ownerDescription;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TightListTile(
      padding: const EdgeInsets.all(15),
      backgroundColor: Theme.of(context).primaryColor,
      leading: RoundedImage.network(
        ownerAvatarUrl?? '',
        width: 50,
        height: 50,
        radius: 8.0,
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonSubTitle1(ownerLoginName),
          if(!CommonUtil.isTextEmpty(ownerDescription))
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: CommonBodyText2(
                ownerDescription,
                maxLine: 3,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            )
        ],
      ),
      onTap: onTap
    );
  }
}