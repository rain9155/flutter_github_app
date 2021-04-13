import 'package:bloc/bloc.dart';
import 'package:flutter_github_app/beans/issue.dart';
import 'package:meta/meta.dart';

part 'states/submit_issue_state.dart';

class SubmitIssueCubit extends Cubit<SubmitIssueState> {
  SubmitIssueCubit() : super(SubmitIssueInitialState());
}
