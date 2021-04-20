
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/beans/label.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/widgets/common_bodytext2.dart';
import 'package:flutter_github_app/widgets/common_subtitle1.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';

import 'custom_divider.dart';

class CommonIssuesItem extends StatelessWidget{

  const CommonIssuesItem({
    this.titleLeading,
    this.title,
    this.date,
    this.bodyLeading,
    this.body,
    this.bodyTrailing,
    this.labelsLeading,
    this.labels,
    this.labelsTrailing,
    this.showDivider = true,
    this.onTap
  });

  final Widget titleLeading;

  final String title;

  final String date;

  final Widget bodyLeading;

  final String body;

  final Widget bodyTrailing;

  final Widget labelsLeading;

  final List<Label> labels;

  final Widget labelsTrailing;

  final bool showDivider;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Theme.of(context).primaryColor,
      child: InkWell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TightListTile(
              crossAlignment: CrossAlignment.top,
              padding: EdgeInsets.only(left: 15, top: 15, right: 15),
              titlePadding: EdgeInsets.only(top: 3, left: 15, right: 15),
              leading: titleLeading?? _buildEmptyIcon(),
              title: CommonSubTitle1(
                title,
                bold: false,
                color: !CommonUtil.isDarkMode(context) ? Colors.grey[600] : Colors.grey,
              ),
              trailing: CommonBodyText2(date),
            ),
            TightListTile(
              crossAlignment: CrossAlignment.top,
              padding: EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 0),
              titlePadding: EdgeInsets.only(left: 15, right: 15),
              leading: bodyLeading?? _buildEmptyIcon(),
              title: CommonSubTitle1(
                body,
                maxLine: 3,
              ),
              trailing: bodyTrailing?? null,
            ),
            if(!CommonUtil.isListEmpty(labels))
              TightListTile(
                crossAlignment: CrossAlignment.top,
                padding: EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 0),
                titlePadding: EdgeInsets.only(left: 15, right: 15),
                leading: labelsLeading?? _buildEmptyIcon(),
                title: Wrap(
                  spacing: 5,
                  children: labels.take(5).map((label){
                    Color backgroundColor = Color(int.tryParse('0xff${label.color}'));
                    return Chip(
                      labelPadding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                      backgroundColor: backgroundColor,
                      label: CommonSubTitle1(
                        label.name,
                        bold: false,
                        color: backgroundColor.computeLuminance() < 0.5 ? Colors.white : Colors.black
                      )
                    );
                  }).toList(),
                ),
                trailing: labelsTrailing?? null,
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

  _buildEmptyIcon(){
    return Icon(
      Icons.add,
      color: Colors.transparent,
    );
  }
}