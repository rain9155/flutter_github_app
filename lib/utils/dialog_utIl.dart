
import 'package:flutter/material.dart';

class DialogUtil{

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

  static dismissDialog(BuildContext context){
    if(ModalRoute.of(context).isActive && !ModalRoute.of(context).isCurrent){
      Navigator.of(context).pop();
    }
  }

}