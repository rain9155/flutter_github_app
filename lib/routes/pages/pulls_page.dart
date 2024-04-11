
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/pull.dart';
import 'package:flutter_github_app/blocs/pulls_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/mixin/load_more_sliverlist_mixin.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/date_util.dart';
import 'package:flutter_github_app/widgets/common_issues_item.dart';
import 'package:flutter_github_app/widgets/empty_page_widget.dart';
import 'package:flutter_github_app/widgets/loading_widget.dart';
import 'package:flutter_github_app/widgets/pull_refresh_widget.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';
import '../webview_route.dart';

// ignore: must_be_immutable
class PullsPage extends StatefulWidget{

  static page(int pageType){
    return BlocProvider(
      create: (_) => PullsBloc(),
      child: PullsPage._(pageType),
    );
  }

  PullsPage._(this.pageType);

  int pageType;

  @override
  State<StatefulWidget> createState() => _PullsPageState();
}

class _PullsPageState extends State<PullsPage> with AutomaticKeepAliveClientMixin, LoadMoreSliverListMixin{

  String? _name;
  String? _repoName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var arguments = ModalRoute.of(context)!.settings.arguments as Map?;
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
      onRefresh: () => context.read<PullsBloc>().refreshPulls()
    );
  }

  Widget _buildBody() {
    return BlocBuilder<PullsBloc, PullsState>(
        builder: (context, state){
          if(state is GettingPullsState){
            return _buildBodyWithLoading(context);
          }
          if(state is GetPullsFailureState){
            return _buildBodyWithFailure(context, state);
          }
          if(state is GetPullsSuccessState){
            return _buildBodyWithSuccess(context, state);
          }
          context.read<PullsBloc>().add(GetPullsEvent(_name, _repoName, widget.pageType));
          return Container();
        }
    );
  }

  Widget _buildBodyWithLoading(BuildContext context) {
    return _buildBodyWithSliver(context, SliverFillRemaining(
      child: LoadingWidget(),
    ));
  }

  Widget _buildBodyWithFailure(BuildContext context, GetPullsFailureState state) {
    if(state.pulls == null){
      return _buildBodyWithSliver(context, SliverFillRemaining(
        child: TryAgainWidget(
            code: state.errorCode,
            onTryPressed: () => context.read<PullsBloc>().add(GetPullsEvent(_name, _repoName, widget.pageType))
        ),
      ));
    }
    return _buildSliverPulls(context, state.pulls, state.hasMore);
  }

  Widget _buildBodyWithSuccess(BuildContext context, GetPullsSuccessState state) {
    return _buildSliverPulls(context, state.pulls, state.hasMore);
  }

  Widget _buildBodyWithSliver(BuildContext context, Widget sliver){
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        sliver
      ],
    );
  }

  Widget _buildSliverPulls(BuildContext context, List<Pull>? pulls, bool hasMore){
    if(CommonUtil.isListEmpty(pulls)){
      return _buildBodyWithSliver(context, SliverFillRemaining(
        child: EmptyPageWidget(AppLocalizations.of(context).noPulls),
      ));
    }
    return _buildBodyWithSliver(context, buildSliverListWithFooter(
        context,
        itemCount: pulls!.length,
        itemBuilder: (context, index){
          Pull pull = pulls[index];
          return CommonIssuesItem(
            titleLeading: Icon(
              Icons.transform,
              color: !CommonUtil.isTextEmpty(pull.mergedAt) ? Colors.purple : !CommonUtil.isTextEmpty(pull.closedAt) ? Colors.redAccent : Colors.blue
            ),
            title: '$_name/$_repoName #${pull.number}',
            date: DateUtil.parseTime(context, pull.createdAt!),
            body: pull.title,
            labels: pull.labels,
            onTap: () => WebViewRoute.push(
              context,
              url: pull.htmlUrl,
            ),
          );
        },
        hasMore: hasMore,
        onLoadMore: () => context.read<PullsBloc>().getMorePulls()
    ));
  }

  @override
  bool get wantKeepAlive => true;

}