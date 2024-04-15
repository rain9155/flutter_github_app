import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_github_app/beans/issue.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/cubits/submit_issue_cubit.dart';
import 'package:flutter_github_app/db/db_helper.dart';
import 'package:flutter_github_app/mixin/bloc_mixin.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

part 'events/create_issue_event.dart';
part 'states/create_issue_state.dart';

class DraftIssue{

  const DraftIssue({
    required this.name,
    required this.repoName,
    this.title,
    this.body
  });

  final String? name;

  final String? repoName;

  final String? title;

  final String? body;
}

class DraftIssuesCache{

  static final tag = 'DraftIssuesCache';

  final String _tableName = 'DraftIssuesCache';
  final String _colId = 'id';
  final String _colName = 'name';
  final String _colRepoName = 'repoName';
  final String _colTitle = 'title';
  final String _colBody = 'body';

  bool _isTableCreated = false;

  Future _createTable() async{
    if(!_isTableCreated){
      await DBHelper.getInstance().execute('''
        CREATE TABLE IF NOT EXISTS $_tableName (
          $_colId integer primary key autoincrement,
          $_colName text not null,
          $_colRepoName text not null,
          $_colTitle text,
          $_colBody text
        )
      ''');
      _isTableCreated = true;
    }
  }

  Future put(String? name, String? repoName, String? title, String? body) async{
    await _createTable();
    await DBHelper.getInstance().insert(
      _tableName, {
        _colName: name,
        _colRepoName: repoName,
        _colTitle: title,
        _colBody: body
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<DraftIssue> get(String? name, String? repoName) async{
    await _createTable();
    List<Map<String, Object?>> results = await DBHelper.getInstance().query(
      _tableName,
      where: '$_colName = ? and $_colRepoName = ?',
      whereArgs: [name, repoName],
      limit: 1
    );
    String? title;
    String? body;
    if(results.isNotEmpty){
      Map result = results[0];
      title = result[_colTitle];
      body = result[_colBody];
    }
    return DraftIssue(
        name: name,
        repoName: repoName,
        title: title,
        body: body
    );
  }

  Future remove(String? name, String? repoName) async{
    await DBHelper.getInstance().delete(
      _tableName,
      where: '$_colName = ? and $_colRepoName = ?',
      whereArgs: [name, repoName],
    );
  }

  Future removeAll() async{
    if(_isTableCreated){
      await DBHelper.getInstance().delete(_tableName);
      _isTableCreated = false;
    }
  }
}


class CreateIssueBloc extends Bloc<CreateIssueEvent, CreateIssueState> with BlocMixin{

  CreateIssueBloc() : super(CreateIssueInitialState()) {
    on<CreateIssueEvent>(mapEventToState, transformer: sequential());
  }

  SubmitIssueCubit submitIssueCubit = SubmitIssueCubit();
  DraftIssuesCache _draftIssuesCache = DraftIssuesCache();
  String? _name;
  String? _repoName;

  FutureOr<void> mapEventToState(CreateIssueEvent event, Emitter<CreateIssueState> emit) async {
    if(event is GetDraftIssueEvent){
      emit(GettingDraftIssueState());
      _name = event.name;
      _repoName = event.repoName;
      DraftIssue draftIssue = await _draftIssuesCache.get(_name, _repoName);
      emit(GetDraftIssueResultState(draftIssue.title?? '', draftIssue.body?? ''));
    }

    if(event is SaveDraftIssueEvent){
      if(!CommonUtil.isTextEmpty(event.title) || !CommonUtil.isTextEmpty(event.body)){
        runBlockCaught(() async{
          await _draftIssuesCache.remove(_name, _repoName);
          await _draftIssuesCache.put(_name, _repoName, event.title, event.body);
        });
      }else{
        runBlockCaught(() async{
          await _draftIssuesCache.remove(_name, _repoName);
        });
      }
    }

    if(event is SubmitCreateIssueEvent){
      submitIssueCubit.emit(SubmittingIssueState());
      await runBlockCaught(() async{
        Issue issue = await Api.getInstance().createIssue(
          name: _name,
          repoName: _repoName,
          title: event.title,
          body: event.body,
          cancelToken: cancelToken
        );
        submitIssueCubit.emit(SubmitIssueResultState(issue: issue));
        _draftIssuesCache.remove(_name, _repoName);
      }, onError: (code, msg){
        submitIssueCubit.emit(SubmitIssueResultState(errorCode: code));
      });
    }
  }

}
