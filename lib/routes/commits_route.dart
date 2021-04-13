
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/commit.dart';
import 'package:flutter_github_app/blocs/commits_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/mixin/load_more_sliverlist_mixin.dart';
import 'package:flutter_github_app/routes/webview_route.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/date_util.dart';
import 'package:flutter_github_app/widgets/common_bodytext2.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/empty_page_widget.dart';
import 'package:flutter_github_app/widgets/loading_widget.dart';
import 'package:flutter_github_app/widgets/rounded_image.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';

class CommitsRoute extends StatelessWidget with LoadMoreSliverListMixin{

  static final name = 'CommitRoute';

  static route(){
    return BlocProvider(
      create: (_) => CommitsBloc(),
      child: CommitsRoute._(),
    );
  }

  static Future push(BuildContext context, {
    @required String name,
    @required String repoName,
    String branch
  }){
    return Navigator.of(context).pushNamed(CommitsRoute.name, arguments: {
      KEY_NAME: name,
      KEY_REPO_NAME: repoName,
      KEY_CHOSEN_BRANCH: branch
    });
  }

  CommitsRoute._();

  String _name;
  String _repoName;
  String _branch;

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context).settings.arguments as Map;
    _name = arguments[KEY_NAME];
    _repoName = arguments[KEY_REPO_NAME];
    _branch = arguments[KEY_CHOSEN_BRANCH];
    return CommonScaffold(
      sliverHeaderBuilder: (context, innerBoxIsScrolled){
        return CommonSliverAppBar(
          title: CommonTitle(AppLocalizations.of(context).commits),
        );
      },
      body: _buildBody(),
      onRefresh: () => context.read<CommitsBloc>().refreshCommits(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<CommitsBloc, CommitsState>(
      builder: (context, state){
        if(state is GettingCommitsState){
          return _buildBodyWithLoading(context);
        }
        if(state is GetCommitsFailureState){
          return _buildBodyWithFailure(context, state);
        }
        if(state is GetCommitsSuccessState){
          return _buildBodyWithSuccess(context, state);
        }
        context.read<CommitsBloc>().add(GetCommitsEvent(_name, _repoName, _branch));
        return Container();
      },
    );
  }

  Widget _buildBodyWithLoading(BuildContext context){
    return LoadingWidget();
  }

  Widget _buildBodyWithFailure(BuildContext context, GetCommitsFailureState state){
    if(state.commits == null){
      return TryAgainWidget(
        code: state.errorCode,
        onTryPressed: () => context.read<CommitsBloc>().add(GetCommitsEvent(_name, _repoName, _branch)),
      );
    }
    return _buildSliverCommits(context, state.commits, state.hasMore);
  }

  Widget _buildBodyWithSuccess(BuildContext context, GetCommitsSuccessState state){
    return _buildSliverCommits(context, state.commits, state.hasMore);
  }

  Widget _buildSliverCommits(BuildContext context, List<Commit> commits, bool hasMore){
    if(CommonUtil.isListEmpty(commits)){
      return EmptyPageWidget(AppLocalizations.of(context).nothing);
    }
    return CustomScrollView(
      slivers: [
        buildSliverListWithFooter(
          context,
          itemCount: commits.length,
          itemBuilder: (context, index){
            Commit commit = commits[index];
            return Ink(
              color: Theme.of(context).primaryColor,
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      TightListTile(
                        titlePadding: EdgeInsets.all(5),
                        leading: Text(
                          commit.commit.message,
                          style: Theme.of(context).textTheme.subtitle2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: CommonBodyText2(DateUtil.parseTime(context, commit.commit.author.date))
                      ),
                      SizedBox(height: 3),
                      TightListTile(
                        titlePadding: EdgeInsets.only(left: 6),
                        leading: RoundedImage.network(
                          commit.author.avatarUrl,
                          width: 20,
                          height: 20,
                          radius: 6,
                        ),
                        title: Text.rich(TextSpan(
                          children: [
                            TextSpan(
                              text: commit.author.login,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            TextSpan(
                              text: ' ${AppLocalizations.of(context).authored} ',
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ]
                        )),
                      )
                    ],
                  ),
                ),
                onTap: () => WebViewRoute.push(
                  context,
                  url: commit.htmlUrl,
                ),
              ),
            );
          },
          hasMore: hasMore,
          onLoadMore: () => context.read<CommitsBloc>().getMoreCommits()
        )
      ],
    );
  }

}