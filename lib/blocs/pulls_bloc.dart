import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_github_app/beans/pull.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/mixin/bloc_mixin.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/net/url.dart';
import 'package:meta/meta.dart';

part 'events/pulls_event.dart';
part 'states/pulls_state.dart';

class PullsBloc extends Bloc<PullsEvent, PullsState> with BlocMixin{

  PullsBloc() : super(PullsInitialState()) {
    on<PullsEvent>(mapEventToState, transformer: sequential());
  }

  String? _name;
  String? _repoName;
  int? _pageType;
  bool _isRefreshing = false;
  List<Pull>? _pulls;
  int _pullsPage = 1;
  int? _pullsLastPage;

  FutureOr<void> mapEventToState(PullsEvent event, Emitter<PullsState> emit) async {
    if(event is GetPullsEvent){
      emit(GettingPullsState());
      _name = event.name;
      _repoName = event.repoName;
      _pageType = event.pageType;
      await refreshPulls(isRefresh: false);
    }

    if(event is GotPullsEvent){
      bool _hasMore = hasMore(_pullsLastPage, _pullsPage);
      if(event.errorCode == null){
        emit(GetPullsSuccessState(_pulls, _hasMore));
      }else{
        emit(GetPullsFailureState(_pulls, _hasMore, event.errorCode));
      }
    }
  }

  Future<void> refreshPulls({bool isRefresh = true}) async{
    if(_isRefreshing){
      return;
    }
    _isRefreshing = true;
    await runBlockCaught(() async{
      _pullsPage = 1;
      _pulls = await _getPullsByType(_pullsPage, isRefresh: isRefresh);
      _pullsLastPage = _getPullsLastPageByType();
      add(GotPullsEvent());
    }, onError: (code, msg){
      add(GotPullsEvent(errorCode: code));
    });
    _isRefreshing = false;
  }

  Future<int?> getMorePulls() async{
    return await (runBlockCaught(() async{
      _pullsPage++;
      _pulls!.addAll(await _getPullsByType(_pullsPage));
      add(GotPullsEvent());
    }, onError: (code, msg){
      _pullsPage--;
      return code;
    }) as FutureOr<int?>);
  }

  int? _getPullsLastPageByType(){
    int? lastPage;
    if(_pageType == PAGE_TYPE_ISSUES_OPEN){
      lastPage = Api.getInstance().getUrlLastPage(Url.repoPullsUrl(_name, _repoName), query: VALUE_OPEN);
    }else{
      lastPage = Api.getInstance().getUrlLastPage(Url.repoPullsUrl(_name, _repoName), query: VALUE_CLOSED);
    }
    return lastPage;
  }

  _removePullsLastPageByType(){
    if(_pageType == PAGE_TYPE_ISSUES_OPEN){
      Api.getInstance().removeUrlLastPage(Url.repoPullsUrl(_name, _repoName), query: VALUE_OPEN);
    }else{
      Api.getInstance().removeUrlLastPage(Url.repoPullsUrl(_name, _repoName), query: VALUE_CLOSED);
    }
  }

  Future<List<Pull>> _getPullsByType(int page, {bool isRefresh = false}) async{
    List<Pull> pulls;
    if(_pageType == PAGE_TYPE_PULLS_OPEN){
      pulls = await Api.getInstance().getRepoPulls(
        name: _name,
        repoName: _repoName,
        state: VALUE_OPEN,
        page: page,
        noCache: isRefresh,
        cancelToken: cancelToken
      );
    }else{
      pulls = await Api.getInstance().getRepoPulls(
        name: _name,
        repoName: _repoName,
        state: VALUE_CLOSED,
        page: page,
        noCache: isRefresh,
        cancelToken: cancelToken
      );
    }
    return pulls;
  }

  @override
  Future<void> close() {
    _removePullsLastPageByType();
    return super.close();
  }

}
