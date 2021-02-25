
import 'package:flutter/material.dart';
import 'package:flutter_github_app/widgets/custom_scroll_config.dart';

class NotificationPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: CustomScrollConfiguration(
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFixedExtentList(
                  itemExtent: 100,
                  delegate: SliverChildBuilderDelegate((context, index){
                    return InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerLeft,
                        child: Text("$index"),
                      ),
                      onTap: (){

                      },
                    );
                  })
              )
            ],
          ),
        ),
        onRefresh: (){
          return Future.delayed(Duration(seconds: 2));
        }
    );
  }

}
