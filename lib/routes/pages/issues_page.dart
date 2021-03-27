import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/issue.dart';
import 'package:flutter_github_app/blocs/issues_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/mixin/load_more_sliverlist_mixin.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/date_util.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:flutter_github_app/widgets/common_issues_item.dart';
import 'package:flutter_github_app/widgets/common_text_box.dart';
import 'package:flutter_github_app/widgets/custom_divider.dart';
import 'package:flutter_github_app/widgets/empty_page_widget.dart';
import 'package:flutter_github_app/widgets/pull_refresh_widget.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';
import '../webview_route.dart';

class IssuesPage extends StatefulWidget{

  static page(int pageType){
    return BlocProvider(
      create: (_) => IssuesBloc(),
      child: IssuesPage._(pageType),
    );
  }

  IssuesPage._(this.pageType) : assert(pageType != null);

  int pageType;

  @override
  _IssuesPageState createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> with LoadMoreSliverListMixin, AutomaticKeepAliveClientMixin{

  String _name;
  String _repoName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var arguments = ModalRoute.of(context).settings.arguments as Map;
    if(arguments != null){
      _name = arguments[KEY_NAME];
      _repoName = arguments[KEY_REPO_NAME];
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PullRefreshWidget(
      key: PageStorageKey(widget.pageType),
      child: _buildBody(),
      onRefresh: () => context.read<IssuesBloc>().refreshIssues()
    );
  }

  Widget _buildBody() {
    return BlocBuilder<IssuesBloc, IssuesState>(
      builder: (context, state){
        if(state is GettingIssuesState){
          return _buildBodyWithLoading(context);
        }
        if(state is GetIssuesFailureState){
          return _buildBodyWithFailure(context, state);
        }
        if(state is GetIssuesSuccessState){
          return _buildBodyWithSuccess(context, state);
        }
        context.read<IssuesBloc>().add(GetIssuesEvent(_name, _repoName, widget.pageType));
        return Container();
      }
    );
  }

  Widget _buildBodyWithLoading(BuildContext context) {
    return _buildBodyWithSliver(context, SliverFillRemaining(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ));
  }

  Widget _buildBodyWithFailure(BuildContext context, GetIssuesFailureState state) {
    if(state.issues == null){
      return _buildBodyWithSliver(context, SliverFillRemaining(
        child: TryAgainWidget(
            code: state.errorCode,
            onTryPressed: () => context.read<IssuesBloc>().add(GetIssuesEvent(_name, _repoName, widget.pageType))
        ),
      ));
    }
    return _buildSliverIssues(context, state.issues, state.hasMore);
  }

  Widget _buildBodyWithSuccess(BuildContext context, GetIssuesSuccessState state) {
    return _buildSliverIssues(context, state.issues, state.hasMore);
  }

  Widget _buildBodyWithSliver(BuildContext context, Widget sliver){
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        sliver
      ],
    );
  }

  Widget _buildSliverIssues(BuildContext context, List<Issue> issues, bool hasMore){
    if(CommonUtil.isListEmpty(issues)){
      return _buildBodyWithSliver(context, SliverFillRemaining(
        child: EmptyPageWidget(AppLocalizations.of(context).noIssues),
      ));
    }
    return _buildBodyWithSliver(context, buildSliverListWithFooter(
      context,
      itemCount: issues.length,
      itemBuilder: (context, index){
        Issue issue = issues[index];
        return CommonIssuesItem(
          titleLeading: Icon(
              Icons.error_outline_outlined,
              color: CommonUtil.isTextEmpty(issue.closedAt) ? Colors.green : Colors.redAccent
          ),
          title: '${issue.title} #${issue.number}',
          date: DateUtil.parseTime(context, issue.createdAt),
          body: issue.body,
          bodyTrailing: issue.comments > 0 ? CommonTextBox(issue.comments.toString()) : null,
          onTap: () => WebViewRoute.push(
            context,
            url: issue.htmlUrl,
          ),
        );
      },
      hasMore: hasMore,
      onLoadMore: () => context.read<IssuesBloc>().getMoreIssues()
    ));
  }

  @override
  bool get wantKeepAlive => true;

}