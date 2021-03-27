
import 'package:flutter/material.dart';
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
    this.showDivider = true,
    this.onTap
  });

  final Widget titleLeading;

  final String title;

  final String date;

  final Widget bodyLeading;

  final String body;

  final Widget bodyTrailing;

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
              title: Text(
                title?? '',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Colors.grey[600]
                ),
              ),
              trailing: Text(
                date?? '',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.grey[600]
                ),
              ),
            ),
            TightListTile(
              crossAlignment: CrossAlignment.top,
              padding: EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 0),
              titlePadding: EdgeInsets.only(left: 15, right: 25),
              leading: bodyLeading?? _buildEmptyIcon(),
              title: Text(
                body?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: Theme.of(context).textTheme.subtitle1
              ),
              trailing: bodyTrailing?? _buildEmptyIcon(),
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