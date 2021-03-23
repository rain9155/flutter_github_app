
import 'package:flutter/material.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/common_util.dart';

/// 支持加载更多的ListView
class LoadMoreWidget extends StatefulWidget{

  const LoadMoreWidget({
    @required this.itemBuilder,
    this.itemCount,
    this.itemExtent,
    this.header,
    this.hasMore,
    this.onLoadMore,
    this.footerHeight = 50
  });

  final IndexedWidgetBuilder itemBuilder;

  final int itemCount;

  final double itemExtent;

  final Widget header;

  final bool hasMore;

  final Future<int> Function() onLoadMore;

  final double footerHeight;

  @override
  _LoadMoreWidgetState createState() => _LoadMoreWidgetState();
}

class _LoadMoreWidgetState extends State<LoadMoreWidget> {

  ScrollController _controller;
  bool _isLoadingMore = false;
  int _errorCode;
  StateSetter _footerSetState;

  @override
  void initState() {
    super.initState();
    if(widget.onLoadMore != null && widget.hasMore){
      _controller = ScrollController();
      _controller.addListener((){
        if(_controller.offset >= _controller.position.maxScrollExtent){
           _loadMore();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int childCount = widget.itemCount;
    bool isShowFooter = widget.onLoadMore != null && widget.hasMore;
    if(widget.itemCount != null && isShowFooter){
      childCount++;
    }
    bool isShowHeader = widget.header != null;
    if(isShowHeader){
      childCount++;
    }
    return ListView.builder(
      itemCount: childCount,
      itemExtent: widget.itemExtent,
      controller: _controller,
      itemBuilder: (context, index){
        if(isShowHeader && index == 0){
          return widget.header;
        }
        if(isShowFooter && index == childCount - 1){
          return _buildFooter(context, widget.footerHeight);
        }
        return widget.itemBuilder?.call(context, isShowHeader ? index - 1 : index);
      },
    );
  }

  Widget _buildFooter(BuildContext context, double height){
      return StatefulBuilder(
        builder: (context, setState){
        _footerSetState = setState;
        Widget child;
        if(_errorCode == null){
          child = Text(AppLocalizations.of(context).loadingMore);
        }else{
          child = TextButton(
            child: Text(
              CommonUtil.getErrorMsgByCode(context, _errorCode) + ', ' + AppLocalizations.of(context).clickTryAgain,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onPressed: (){
              setState(() => _errorCode = null);
              _loadMore();
            }
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

  Future _loadMore() async {
    if(!_isLoadingMore){
      _isLoadingMore = true;
      int code = await widget.onLoadMore?.call();
      _isLoadingMore = false;
      if(code != null){
        _footerSetState(() => _errorCode = code);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}