import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_github_app/beans/branch.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/mixin/bloc_mixin.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/net/url.dart';
import 'package:meta/meta.dart';

part 'events/branches_event.dart';
part 'states/branches_state.dart';

class BranchesBloc extends Bloc<BranchesEvent, BranchesState> with BlocMixin{

  BranchesBloc() : super(BranchesInitialState());

  bool _isRefreshing = false;
  String _name;
  String _repoName;
  List<Branch> _branches;
  int _branchesPage = 1;
  int _branchesLastPage;

  @override
  Stream<BranchesState> mapEventToState(BranchesEvent event) async* {
    if(event is GetBranchesEvent){
      yield GettingBranchesState();
      _name = event.name;
      _repoName = event.repoName;
      await refreshBranches(isRefresh: false);
    }

    if(event is GotBranchesEvent){
      bool _hasMore = hasMore(_branchesLastPage, _branchesPage);
      if(event.errorCode == null){
        yield GetBranchesSuccessState(_branches, _hasMore);
      }else{
        yield GetBranchesFailureState(_branches, _hasMore, event.errorCode);
      }
    }
  }

  Future<void> refreshBranches({bool isRefresh = true}) async{
    if(_isRefreshing){
      return;
    }
    _isRefreshing = true;
    await runBlockCaught(() async{
      _branchesPage = 1;
      _branches = await _getBranches(_branchesPage, isRefresh: isRefresh);
      _branchesLastPage = Api.getInstance().getUrlLastPage(Url.branchesUrl(_name, _repoName));
      add(GotBranchesEvent());
    }, onError: (code, msg){
      add(GotBranchesEvent(errorCode: code));
    });
    _isRefreshing = false;
  }

  Future<int> getMoreBranches() async{
    return await runBlockCaught(() async{
      _branchesPage++;
      _branches.addAll(await _getBranches(_branchesPage));
      add(GotBranchesEvent());
    }, onError: (code, msg){
      _branchesPage--;
      return code;
    });
  }

  Future<List<Branch>> _getBranches(int page, {bool isRefresh = false}){
    return Api.getInstance().getBranches(
        name: _name,
        repoName: _repoName,
        page: page,
        noCache: isRefresh,
        cancelToken: cancelToken
    );
  }

  @override
  Future<void> close() {
    Api.getInstance().removeUrlLastPage(Url.branchesUrl(_name, _repoName));
    return super.close();
  }
}
