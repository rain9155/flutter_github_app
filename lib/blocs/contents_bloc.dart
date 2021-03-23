import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_github_app/beans/content.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/mixin/bloc_mixin.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:meta/meta.dart';

part 'events/contents_event.dart';
part 'states/contents_state.dart';

class ContentsBloc extends Bloc<ContentsEvent, ContentsState> with BlocMixin{

  ContentsBloc() : super(ContentsInitialState());

  bool _isRefreshing = false;
  List<Content> _contents;
  String _name;
  String _repoName;
  String _path;
  String _branch;

  @override
  Stream<ContentsState> mapEventToState(ContentsEvent event) async* {
    if(event is GetContentsEvent){
      yield GettingContentsState();
      _name = event.name;
      _repoName = event.repoName;
      _path = event.path;
      _branch = event.branch;
      await refreshContents(isRefresh: false);
    }

    if(event is GotContentsEvent){
      if(event.errorCode == null){
        yield GetContentsSuccessState(_contents);
      }else{
        yield GetContentsFailureState(_contents, event.errorCode);
      }
    }
  }

  Future<void> refreshContents({bool isRefresh = true}) async{
    if(_isRefreshing){
      return;
    }
    _isRefreshing = true;
    await runBlockCaught(() async{
       List<Content> contents = await Api.getInstance().getContents(
          name: _name,
          repoName: _repoName,
          path: _path,
          ref: _branch,
          noCache: isRefresh,
          cancelToken: cancelToken
       );
       if(!CommonUtil.isListEmpty(contents)){
         _contents = [];
         contents.forEach((element) {
           if(element.type == CONTENT_TYPE_DIR){
             _contents.insert(0, element);
           }else{
             _contents.add(element);
           }
         });
       }
       add(GotContentsEvent());
    }, onError: (code, msg){
      add(GotContentsEvent(errorCode: code));
    });
    _isRefreshing = false;
  }

}
