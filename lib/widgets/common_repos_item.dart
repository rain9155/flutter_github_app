import 'package:flutter/material.dart';
import 'package:flutter_github_app/widgets/common_bodytext2.dart';
import 'package:flutter_github_app/widgets/common_subtitle1.dart';
import 'package:flutter_github_app/widgets/simple_chip.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/widgets/rounded_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'custom_divider.dart';
import 'tight_list_tile.dart';

class CommonReposItem extends StatelessWidget{

  const CommonReposItem({
    this.ownerAvatarUrl,
    this.ownerLoginName,
    this.repoName,
    this.repoDescription,
    this.stargazersCount,
    this.language,
    this.showDivider = true,
    this.onTap
  });

  final String? ownerAvatarUrl;

  final String? ownerLoginName;

  final String? repoName;

  final String? repoDescription;

  final int? stargazersCount;

  final String? language;

  final bool showDivider;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Theme.of(context).primaryColor,
      child: InkWell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(!CommonUtil.isTextEmpty(ownerAvatarUrl) || !CommonUtil.isTextEmpty(ownerLoginName))
              TightListTile(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                titlePadding: EdgeInsets.only(left: 10),
                leading: RoundedImage.network(
                  ownerAvatarUrl?? '',
                  width: 25,
                  height: 25,
                  radius: 6.0,
                ),
                title: CommonBodyText2(
                  ownerLoginName,
                  color: Colors.grey,
                )
              ),
            if(!CommonUtil.isTextEmpty(repoName))
              Container(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: CommonSubTitle1(repoName)
              ),
            if(!CommonUtil.isTextEmpty(repoDescription))
              Container(
                padding: EdgeInsets.fromLTRB(15, 2, 15, 0),
                child: MarkdownBody(
                  data: repoDescription!,
                  extensionSet: md.ExtensionSet.gitHubWeb,
                ),
              ),
            if(stargazersCount != null || !CommonUtil.isTextEmpty(language))
              TightListTile(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                leading: stargazersCount == null ? null : SimpleChip(
                  avatar: Icon(
                      Icons.star,
                      color: Colors.yellow
                  ),
                  label: CommonBodyText2(CommonUtil.numToThousand(stargazersCount))
                ),
                title: CommonUtil.isTextEmpty(language) ? null : SimpleChip(
                  avatar: Icon(
                    Icons.fiber_manual_record,
                    size: 15,
                    color: Colors.brown,
                  ),
                  label: CommonBodyText2(language)
                )
              ),
            if(showDivider)
              Container(
                padding: EdgeInsets.only(top: 20),
                child: CustomDivider(),
              )
            else
              Padding(
                padding: EdgeInsets.only(top: 20),
              )
          ],
        ),
        onTap: onTap
      ),
    );
  }
}