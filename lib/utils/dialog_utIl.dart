

import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/callback.dart';

class DialogUtil{

  DialogUtil._();

  static dismiss(BuildContext context, {
    bool isDialogContext = true,
    dynamic result
  }) async{
    if(isDialogContext){
      if(ModalRoute.of(context)!.isActive){
        Navigator.of(context).pop(result);
      }
    }else{
      if(ModalRoute.of(context)!.isActive && !ModalRoute.of(context)!.isCurrent){
        Navigator.of(context).pop();
      }
    }
  }

  static showLoading(BuildContext context, {dismissible = false}){
    if(ModalRoute.of(context)!.isCurrent){
      showDialog(
        context: context,
        barrierDismissible: dismissible,
        builder: (context){
          return PopScope(
            canPop: dismissible,
            child: AlertDialog(
              backgroundColor: Theme.of(context).primaryColor,
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

  static Future<T?> showAlert<T>(BuildContext context, {
    WidgetBuilder? titleBuilder,
    WidgetBuilder? contentBuilder,
    WidgetsBuilder? actionsBuilder,
    EdgeInsets titlePadding = const EdgeInsets.fromLTRB(20, 15, 20, 0),
    EdgeInsets contextPadding = const EdgeInsets.fromLTRB(20, 15, 20, 0),
    dismissible = true
  }) async {
    if(ModalRoute.of(context)!.isCurrent){
      return await showDialog<T>(
        context: context,
        barrierDismissible: dismissible,
        builder: (context){
          return PopScope(
            canPop: dismissible,
            child: AlertDialog(
              titlePadding: titlePadding,
              contentPadding: contextPadding,
              backgroundColor: Theme.of(context).primaryColor,
              title: titleBuilder?.call(context),
              content: contentBuilder?.call(context),
              actions: actionsBuilder?.call(context),
            ),
          );
        }
      );
    }
    return null;
  }

  static Future<T?> showSimple<T>(BuildContext context, {
    WidgetBuilder? titleBuilder,
    WidgetsBuilder? childrenBuilder,
    EdgeInsets titlePadding = const EdgeInsets.fromLTRB(20, 10, 20, 0),
    EdgeInsets contextPadding = const EdgeInsets.fromLTRB(0, 10, 0, 10),
    dismissible = true
  }) async {
    if(ModalRoute.of(context)!.isCurrent){
      return await showDialog<T>(
        context: context,
        barrierDismissible: dismissible,
        builder: (context){
          return PopScope(
            canPop: dismissible,
            child: SimpleDialog(
              titlePadding: titlePadding,
              contentPadding: contextPadding,
              backgroundColor: Theme.of(context).primaryColor,
              title: titleBuilder?.call(context),
              children: childrenBuilder?.call(context),
            ),
          );
        }
      );
    }
    return null;
  }

  static Future<T?> showFullDialog<T>(BuildContext context, {
    required WidgetBuilder builder,
    RouteSettings? routeSettings
  }) async{
    if(ModalRoute.of(context)!.isCurrent){
      return await Navigator.of(context).push(MaterialPageRoute(
        builder: builder,
        fullscreenDialog: true,
        settings: routeSettings
      ));
    }
    return null;
  }

  static Future<T?> showBottomSheet<T>(BuildContext context, {
    required WidgetBuilder builder,
    RouteSettings? routeSettings,
    bool isFullScreen = false
  }) async {
    if(ModalRoute.of(context)!.isCurrent){
      return await showModalBottomSheet(
        context: context,
        builder: builder,
        backgroundColor: Colors.transparent,
        routeSettings: routeSettings,
        isScrollControlled: isFullScreen
      );
    }
    return null;
  }
}