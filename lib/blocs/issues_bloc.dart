import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_github_app/beans/issue.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/mixin/bloc_mixin.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/net/url.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:meta/meta.dart';

part 'events/issues_event.dart';
part 'states/issues_state.dart';

class IssuesBloc extends Bloc<IssuesEvent, IssuesState> with BlocMixin{

  IssuesBloc() : super(IssuesInitialState()) {
    on<IssuesEvent>(mapEventToState, transformer: sequential());
  }

  String? _name;
  String? _repoName;
  int? _pageType;
  bool _isRefreshing = false;
  List<Issue>? _issues;
  int _issuesPage = 1;
  int? _issuesLastPage;

  FutureOr<void> mapEventToState(IssuesEvent event, Emitter<IssuesState> emit) async {
    if(event is GetIssuesEvent){
      emit(GettingIssuesState());
      _name = event.name;
      _repoName = event.repoName;
      _pageType = event.pageType;
      await refreshIssues(isRefresh: false);
    }

    if(event is GotIssuesEvent){
      bool _hasMore = hasMore(_issuesLastPage, _issuesPage);
      if(event.errorCode == null){
        emit(GetIssuesSuccessState(_issues, _hasMore));
      }else{
        emit(GetIssuesFailureState(_issues, _hasMore, event.errorCode));
      }
    }
  }

  Future<void> refreshIssues({bool isRefresh = true}) async{
    if(_isRefreshing){
      return;
    }
    _isRefreshing = true;
    await runBlockCaught(() async{
      _issuesPage = 1;
      _issues = await _getIssuesByType(_issuesPage, isRefresh: isRefresh);
      _issuesLastPage = _getIssuesLastPageByType();
      add(GotIssuesEvent());
    }, onError: (code, msg){
      add(GotIssuesEvent(errorCode: code));
    });
    _isRefreshing = false;
  }

  Future<int?> getMoreIssues() async{
    return await runBlockCaught(() async{
      _issuesPage++;
      _issues!.addAll(await _getIssuesByType(_issuesPage));
      add(GotIssuesEvent());
    }, onError: (code, msg){
      _issuesPage--;
      return code;
    });
  }

  int? _getIssuesLastPageByType(){
    int? lastPage;
    if(_pageType == PAGE_TYPE_ISSUES_OPEN){
      lastPage = Api.getInstance().getUrlLastPage(Url.repoIssuesUrl(_name, _repoName), query: VALUE_OPEN);
    }else if(_pageType == PAGE_TYPE_ISSUES_CLOSED){
      lastPage = Api.getInstance().getUrlLastPage(Url.repoIssuesUrl(_name, _repoName), query: VALUE_CLOSED);
    }else if(_pageType == PAGE_TYPE_ISSUES_MENTIONED){
      lastPage = Api.getInstance().getUrlLastPage(Url.issuesUrl(), query: VALUE_MENTIONED);
    }else if(_pageType == PAGE_TYPE_ISSUES_ASSIGNED){
      lastPage = Api.getInstance().getUrlLastPage(Url.issuesUrl(), query: VALUE_ASSIGNED);
    }else{
      lastPage = Api.getInstance().getUrlLastPage(Url.issuesUrl(), query: VALUE_CREATED);
    }
    return lastPage;
  }

  _removeIssuesLastPageByType(){
    if(_pageType == PAGE_TYPE_ISSUES_OPEN){
      Api.getInstance().removeUrlLastPage(Url.repoIssuesUrl(_name, _repoName), query: VALUE_OPEN);
    }else if(_pageType == PAGE_TYPE_ISSUES_CLOSED){
      Api.getInstance().removeUrlLastPage(Url.repoIssuesUrl(_name, _repoName), query: VALUE_CLOSED);
    }else if(_pageType == PAGE_TYPE_ISSUES_MENTIONED){
      Api.getInstance().removeUrlLastPage(Url.issuesUrl(), query: VALUE_MENTIONED);
    }else if(_pageType == PAGE_TYPE_ISSUES_ASSIGNED){
      Api.getInstance().removeUrlLastPage(Url.issuesUrl(), query: VALUE_ASSIGNED);
    }else{
      Api.getInstance().removeUrlLastPage(Url.issuesUrl(), query: VALUE_CREATED);
    }
  }

  Future<List<Issue>> _getIssuesByType(int page, {bool isRefresh = false}) async{
    List<Issue> issues;
    if(_pageType == PAGE_TYPE_ISSUES_OPEN){
      issues = await Api.getInstance().getRepoIssues(
        name: _name,
        repoName: _repoName,
        state: VALUE_OPEN,
        page: page,
        noCache: isRefresh,
        cancelToken: cancelToken
      );
    }else if(_pageType == PAGE_TYPE_ISSUES_CLOSED){
      issues = await Api.getInstance().getRepoIssues(
          name: _name,
          repoName: _repoName,
          state: VALUE_CLOSED,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else if(_pageType == PAGE_TYPE_ISSUES_MENTIONED){
      issues = await Api.getInstance().getIssues(
          filter: VALUE_MENTIONED,
          state: VALUE_OPEN,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else if(_pageType == PAGE_TYPE_ISSUES_ASSIGNED){
      issues = await Api.getInstance().getIssues(
          filter: VALUE_ASSIGNED,
          state: VALUE_OPEN,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else{
      issues = await Api.getInstance().getIssues(
          filter: VALUE_CREATED,
          state: VALUE_OPEN,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }
    if(!CommonUtil.isListEmpty(issues)){
      issues.removeWhere((element) => element.pullRequest != null);
    }
    return issues;
  }

  @override
  Future<void> close() {
    _removeIssuesLastPageByType();
    return super.close();
  }
}
