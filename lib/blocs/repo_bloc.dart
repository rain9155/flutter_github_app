import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:flutter_github_app/beans/repository.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/cubits/branch_cubit.dart';
import 'package:flutter_github_app/cubits/readme_cubit.dart';
import 'package:flutter_github_app/cubits/star_cubit.dart';
import 'package:flutter_github_app/mixin/bloc_mixin.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:meta/meta.dart';

part 'events/repo_event.dart';
part 'states/repo_state.dart';

class RepoBloc extends Bloc<RepoEvent, RepoState> with BlocMixin{

  RepoBloc() : super(RepoInitialState()) {
    on<RepoEvent>(mapEventToState, transformer: sequential());
  }

  BranchCubit branchCubit = BranchCubit();
  StarCubit starCubit = StarCubit();
  ReadmeCubit readmeCubit = ReadmeCubit();
  String? _url;
  String? _name;
  String? _repoName;
  bool _isRefreshing = false;
  Repository? _repository;
  bool? _isStarred;
  String? _readmd;
  String? _chosenBranch;

  FutureOr<void> mapEventToState(RepoEvent event, Emitter<RepoState> emit) async {
    if(event is GetRepoEvent){
      emit(GettingRepoState());
      _url = event.url;
      _name = event.name;
      _repoName = event.repoName;
      await refreshRepo(isRefresh: false);
    }

    if(event is GotRepoEvent){
      if(event.errorCode == null){
        emit(GetRepoSuccessState(_repository, _isStarred, _chosenBranch,  _readmd));
      }else{
        emit(GetRepoFailureState(_repository, _isStarred, _chosenBranch, _readmd, event.errorCode));
      }
    }

    if(event is StarRepoEvent){
      starCubit.emit(StarringRepoState());
      bool success;
      if(event.star){
        success = await Api.getInstance().starRepo(
            name: _name,
            repoName: _repoName,
            cancelToken: cancelToken
        );
        _isStarred = success;
      }else {
        success = await Api.getInstance().unStarRepo(
            name: _name,
            repoName: _repoName,
            cancelToken: cancelToken
        );
        _isStarred = !success;
      }
      starCubit.emit(StarRepoResultState(_isStarred));
    }

    if(event is ChangeBranchEvent){
      if(!CommonUtil.isTextEmpty(event.branch) && event.branch != _chosenBranch){
        _chosenBranch = event.branch;
        branchCubit.emit(ChangeBranchResultState(_chosenBranch));
        add(UpdateReadmeEvent());
      }
    }

    if(event is UpdateReadmeEvent){
      readmeCubit.emit(UpdatingReadmeState());
      await runBlockCaught(() async{
        _readmd = await _getReadme(_chosenBranch);
        readmeCubit.emit(UpdateReadmeResultState(readme: _readmd));
      }, onError: (code, msg){
        _readmd = null;
        readmeCubit.emit(UpdateReadmeResultState(errorCode: code));
      });
    }
  }

  Future<void> refreshRepo({bool isRefresh = true}) async{
    if(_isRefreshing){
      return;
    }
    _isRefreshing = true;
    await runBlockCaught(() async{
        Future getRepository() async{
          _repository = await Api.getInstance().getRepository(
              url: _url,
              name: _name,
              repoName: _repoName,
              noCache: isRefresh,
              cancelToken: cancelToken
          );
          _name = _name?? _repository!.owner!.login;
          _repoName = _repoName?? _repository!.name;
          _chosenBranch = _chosenBranch?? _repository!.defaultBranch;
        }
       Future checkStarredRepo() async{
         _isStarred = await Api.getInstance().checkUserStarRepo(
             name: _name,
             repoName: _repoName,
             noCache: isRefresh,
             cancelToken: cancelToken
         );
       }
       Future getReadme() async{
         _readmd = await _getReadme(_chosenBranch, isRefresh: isRefresh);
       }
       if(CommonUtil.isTextEmpty(_name) || CommonUtil.isTextEmpty(_repoName)){
         await getRepository();
         await Future.wait([checkStarredRepo(), getReadme()], eagerError: true);
       }else{
         await Future.wait([getRepository(), checkStarredRepo(), getReadme()], eagerError: true);
       }
      add(GotRepoEvent());
    }, onError: (code, msg){
      cancelToken.cancel();
      cancelToken = CancelToken();
      add(GotRepoEvent(errorCode: code));
    });
    _isRefreshing = false;
  }

  Future<String?> _getReadme(String? branch, {bool isRefresh = false}){
    return Api.getInstance().getReadme(
      name: _name,
      repoName: _repoName,
      ref: branch,
      noCache: isRefresh,
      cancelToken: cancelToken
    );
  }
}
