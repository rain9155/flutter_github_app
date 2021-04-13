
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/blocs/create_issue_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/cubits/submit_issue_cubit.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/routes/webview_route.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/toast_util.dart';
import 'package:flutter_github_app/widgets/common_action.dart';
import 'package:flutter_github_app/widgets/common_appbar.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/custom_scroll_config.dart';
import 'package:flutter_github_app/widgets/custom_single_child_scroll_view.dart';
import 'package:flutter_github_app/widgets/loading_widget.dart';

class CreateIssueRoute extends StatefulWidget{

  static final name = 'CreateIssueRoute';

  static route(){
    return BlocProvider(
      create: (_) => CreateIssueBloc(),
      child: CreateIssueRoute._(),
    );
  }

  static Future push(BuildContext context, {
    @required String name,
    @required String repoName,
  }){
    return Navigator.of(context).pushNamed(CreateIssueRoute.name, arguments: {
      KEY_NAME: name,
      KEY_REPO_NAME: repoName
    });
  }

  CreateIssueRoute._();

  @override
  _CreateIssueRouteState createState() => _CreateIssueRouteState();
}

class _CreateIssueRouteState extends State<CreateIssueRoute> {

  TextEditingController _titleController;
  TextEditingController _bodyController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var arguments = ModalRoute.of(context).settings.arguments as Map;
    context.read<CreateIssueBloc>().add(GetDraftIssueEvent(arguments[KEY_NAME], arguments[KEY_REPO_NAME]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  CommonAppBar _buildAppBar(BuildContext context) {
    return CommonAppBar(
      onBack: () async{
        context.read<CreateIssueBloc>().add(SaveDraftIssueEvent(_titleController?.text, _bodyController?.text));
        return true;
      },
      title: CommonTitle(AppLocalizations.of(context).createIssue),
      actions: [
        BlocBuilder<SubmitIssueCubit, SubmitIssueState>(
          cubit: context.read<CreateIssueBloc>().submitIssueCubit,
          builder: (context, state){
            if(state is SubmittingIssueState){
              return UnconstrainedBox(
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: LoadingWidget(isScroll: false),
                ),
              );
            }
            if(state is SubmitIssueResultState){
              if(state.issue == null){
                ToastUtil.showToast(CommonUtil.getErrorMsgByCode(context, state.errorCode));
              }else{
                Future.delayed(Duration(microseconds: 500), () => WebViewRoute.popAndPush(context, url: state.issue.htmlUrl));
              }
            }
            return CommonAction(
              icon: Icons.send_outlined,
              tooltip: AppLocalizations.of(context).submit,
              onPressed: (){
                if(_titleController.text.trim().isEmpty){
                  ToastUtil.showSnackBar(
                    context,
                    msg: AppLocalizations.of(context).issueTitleEmpty,
                    backgroundColor: Theme.of(context).backgroundColor,
                  );
                  return;
                }
                context.read<CreateIssueBloc>().add(SubmitCreateIssueEvent(_titleController.text, _bodyController.text));
              },
            );
          },
        ),
      ],
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return CustomScrollConfiguration(
      child: WillPopScope(
        onWillPop: () async{
          context.read<CreateIssueBloc>().add(SaveDraftIssueEvent(_titleController?.text, _bodyController?.text));
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CustomSingleChildScrollView(
            child: BlocBuilder<CreateIssueBloc, CreateIssueState>(
              builder: (context, state){
                if(state is GettingDraftIssueState){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(state is GetDraftIssueResultState){
                  if(_titleController == null){
                    _titleController = TextEditingController();
                    _titleController.text = state.title;
                    _titleController.selection = TextSelection.fromPosition(TextPosition(offset: state.title.length));
                  }
                  if(_bodyController == null){
                    _bodyController = TextEditingController();
                    _bodyController.text = state.body;
                    _bodyController.selection = TextSelection.fromPosition(TextPosition(offset: state.body.length));
                  }
                }
                return Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      autofocus: true,
                      maxLines: null,
                      cursorColor: Theme.of(context).accentColor,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontWeight: FontWeight.w600
                      ),
                      decoration: _buildInputDecoration(AppLocalizations.of(context).issueHintTitle)
                    ),
                    TextField(
                      controller: _bodyController,
                      maxLines: null,
                      cursorColor: Theme.of(context).accentColor,
                      decoration: _buildInputDecoration(AppLocalizations.of(context).issueHintBody),
                    )
                  ],
                );
              },
            ),
          )
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint){
    return InputDecoration(
      hintText: hint,
      hintStyle: Theme.of(context).textTheme.subtitle1.copyWith(
          color: Theme.of(context).disabledColor
      ),
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none
    );
  }

  @override
  void dispose() {
    _titleController?.dispose();
    _bodyController?.dispose();
    super.dispose();
  }
}