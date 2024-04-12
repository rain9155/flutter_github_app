import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_github_app/beans/commit.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/mixin/bloc_mixin.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/net/url.dart';
import 'package:meta/meta.dart';

part 'events/commits_event.dart';
part 'states/commits_state.dart';

class CommitsBloc extends Bloc<CommitsEvent, CommitsState> with BlocMixin{

  CommitsBloc() : super(CommitsInitialState()) {
    on<CommitsEvent>(mapEventToState, transformer: sequential());
  }

  bool _isRefreshing = false;
  List<Commit>? _commits;
  int _commitsPage = 1;
  int? _commitsLastPage;
  String? _name;
  String? _repoName;
  String? _branch;

  FutureOr<void> mapEventToState(CommitsEvent event, Emitter<CommitsState> emit) async {
    if(event is GetCommitsEvent){
      emit(GettingCommitsState());
      _name = event.name;
      _repoName = event.repoName;
      _branch = event.branch;
      await refreshCommits(isRefresh: false);
    }

    if(event is GotCommitsEvent){
      bool _hasMore = hasMore(_commitsLastPage, _commitsPage);
      if(event.errorCode == null){
        emit(GetCommitsSuccessState(_commits, _hasMore));
      }else{
        emit(GetCommitsFailureState(_commits, _hasMore, event.errorCode));
      }
    }
  }

  Future<void> refreshCommits({bool isRefresh = true}) async{
    if(_isRefreshing){
      return;
    }
    _isRefreshing = true;
    await runBlockCaught(() async{
      _commitsPage = 1;
      _commits = await _getCommits(_commitsPage, isRefresh: isRefresh);
      _commitsLastPage = Api.getInstance().getUrlLastPage(Url.commitsUrl(_name, _repoName));
      add(GotCommitsEvent());
    }, onError: (code, msg){
      add(GotCommitsEvent(errorCode: code));
    });
    _isRefreshing = false;
  }

  Future<int?> getMoreCommits() async{
    return await runBlockCaught(() async{
      _commitsPage++;
      _commits!.addAll(await _getCommits(_commitsPage));
      add(GotCommitsEvent());
    }, onError: (code, msg){
      _commitsPage--;
      return code;
    });
  }

  Future<List<Commit>> _getCommits(int page, {bool isRefresh = false}){
    return Api.getInstance().getCommits(
      name: _name,
      repoName: _repoName,
      ref: _branch,
      page: page,
      noCache: isRefresh,
      cancelToken: cancelToken
    );
  }

  @override
  Future<void> close() {
    Api.getInstance().removeUrlLastPage(Url.commitsUrl(_name, _repoName));
    return super.close();
  }
}
