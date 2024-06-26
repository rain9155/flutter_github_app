import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/mixin/bloc_mixin.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:meta/meta.dart';

part 'events/content_event.dart';
part 'states/content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> with BlocMixin{

  ContentBloc() : super(ContentInitialState()) {
    on<ContentEvent>(mapEventToState, transformer: sequential());
  }

  bool _isRefreshing = false;
  String? _content;
  String? _name;
  String? _repoName;
  String? _path;
  String? _branch;

  FutureOr<void> mapEventToState(ContentEvent event, Emitter<ContentState> emit) async {
    if(event is GetContentEvent){
      emit(GettingContentState());
      _name = event.name;
      _repoName = event.repoName;
      _path = event.path;
      _branch = event.branch;
      await refreshContent(isRefresh: false);
    }

    if(event is GotContentEvent){
      if(event.errorCode == null){
        emit(GetContentSuccessState(_content));
      }else{
        emit(GetContentFailureState(_content, event.errorCode));
      }
    }
  }

  Future<void> refreshContent({bool isRefresh = true}) async{
    if(_isRefreshing){
      return;
    }
    _isRefreshing = true;
    await runBlockCaught(() async{
      _content = await Api.getInstance().getContent(
          name: _name,
          repoName: _repoName,
          path: _path,
          ref: _branch,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
      add(GotContentEvent());
    }, onError: (code, msg){
      add(GotContentEvent(errorCode: code));
    });
    _isRefreshing = false;
  }

}
