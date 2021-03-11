
import 'package:flutter/material.dart';

class DialogUtil{

  static dismiss(BuildContext context){
    if(ModalRoute.of(context).isActive && !ModalRoute.of(context).isCurrent){
      Navigator.of(context).pop();
    }
  }

  static showLoading(BuildContext context, {dismissible = false}){
    if(ModalRoute.of(context).isCurrent){
      showDialog(
          context: context,
          barrierDismissible: dismissible,
          builder: (context){
            return WillPopScope(
              onWillPop: () async{
                return dismissible;
              },
              child: AlertDialog(
                content: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            );
          }
      );
    }
  }

  static showBottomSheet({
    @required BuildContext context,
    @required WidgetBuilder builder,
    RouteSettings routeSettings
  }){
    if(ModalRoute.of(context).isCurrent){
      showModalBottomSheet(
        context: context,
        builder: builder,
        routeSettings: routeSettings
      );
    }
  }

}