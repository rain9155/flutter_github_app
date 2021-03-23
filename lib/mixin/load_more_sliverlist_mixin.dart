import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/callback.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/common_util.dart';


/// SliverList实现加载更多
mixin LoadMoreSliverListMixin{

  Widget buildSliverListWithFooter(BuildContext context, {
    @required IndexedWidgetBuilder itemBuilder,
    int itemCount,
    double itemExtent,
    bool hasMore,
    LoadMoreCallback onLoadMore,
    double footerHeight = 50
  }){
    int childCount = itemCount;
    bool isShowFooter = onLoadMore != null && hasMore;
    if(itemCount != null && isShowFooter){
      childCount++;
    }
    SliverChildBuilderDelegate delegate = SliverChildBuilderDelegate(
      (context, index){
        if(isShowFooter && index == itemCount){
          return _buildFooter(context, onLoadMore, footerHeight);
        }
        return itemBuilder?.call(context, index);
      },
      childCount: childCount
    );
    return itemExtent == null
        ? SliverList(delegate: delegate)
        : SliverFixedExtentList(delegate: delegate, itemExtent: itemExtent);
  }

  int _errorCode;
  bool _isLoadingMore = false;
  StateSetter _footerSetState;

  Widget _buildFooter(BuildContext context, LoadMoreCallback onLoadMore, double height){
    return StatefulBuilder(
      builder: (context, setState){
        _footerSetState = setState;
        if(!_isLoadingMore && _errorCode == null){
          _isLoadingMore = true;
          onLoadMore?.call()?.then((code){
            _isLoadingMore = false;
            _errorCode = code;
            _footerSetState((){});
          });
        }
        Widget child;
        if(_errorCode == null){
          child = Text(AppLocalizations.of(context).loadingMore);
        }else{
          child = TextButton(
            child: Text(
              CommonUtil.getErrorMsgByCode(context, _errorCode) + ', ' + AppLocalizations.of(context).clickTryAgain,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onPressed: () => setState(() => _errorCode = null),
          );
        }
        return Container(
          height: height,
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }

}