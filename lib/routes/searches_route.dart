
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/issue.dart';
import 'package:flutter_github_app/beans/owner.dart';
import 'package:flutter_github_app/beans/repository.dart';
import 'package:flutter_github_app/blocs/searches_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/mixin/load_more_sliverlist_mixin.dart';
import 'package:flutter_github_app/routes/profile_route.dart';
import 'package:flutter_github_app/routes/repo_route.dart';
import 'package:flutter_github_app/routes/webview_route.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/date_util.dart';
import 'package:flutter_github_app/widgets/common_issues_item.dart';
import 'package:flutter_github_app/widgets/common_owners_item.dart';
import 'package:flutter_github_app/widgets/common_repos_item.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_text_box.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/empty_page_widget.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';

class SearchesRoute extends StatelessWidget with LoadMoreSliverListMixin{

  static final name = 'SearchesRoute';

  static route(){
    return BlocProvider(
      create: (_) => SearchesBloc(),
      child: SearchesRoute._(),
    );
  }

  static Future push(BuildContext context, {
    @required String key,
    int routeType = ROUTE_TYPE_SEARCHES_REPO
  }){
    return Navigator.of(context).pushNamed(SearchesRoute.name, arguments: {
      KEY_SEARCH_KEY: key,
      KEY_ROUTE_TYPE: routeType
    });
  }

  SearchesRoute._();

  String _key;
  int _routeType;

  @override
  Widget build(BuildContext context) {
    var argument = ModalRoute.of(context).settings.arguments as Map;
    _key = argument[KEY_SEARCH_KEY];
    _routeType = argument[KEY_ROUTE_TYPE];
    return CommonScaffold(
      sliverHeaderBuilder: (context, _){
        return _buildSliverAppBar(context);
      },
      body: _buildBody(),
      onRefresh: () => context.read<SearchesBloc>().refreshSearches(),
    );
  }

  Widget _buildSliverAppBar(BuildContext context){
    String getTitle(){
      switch(_routeType){
        case ROUTE_TYPE_SEARCHES_ISSUE:
          return AppLocalizations.of(context).issues;
        case ROUTE_TYPE_SEARCHES_PULL:
          return AppLocalizations.of(context).pullRequests;
        case ROUTE_TYPE_SEARCHES_USER:
          return AppLocalizations.of(context).people;
        case ROUTE_TYPE_SEARCHES_ORG:
          return AppLocalizations.of(context).orgs;
        default:
          return AppLocalizations.of(context).repos;
      }
    }
    return CommonSliverAppBar(
      title: CommonTitle(getTitle()),
    );
  }

  Widget _buildBody(){
    return BlocBuilder<SearchesBloc, SearchesState>(
      builder: (context, state){
        if(state is GettingSearchesState){
          return _buildBodyWithLoading(context);
        }
        if(state is GetSearchesFailureState){
          return _buildBodyWithFailure(context, state);
        }
        if(state is GetSearchesSuccessState){
          return _buildBodyWithSuccess(context, state);
        }
        context.read<SearchesBloc>().add(GetSearchesEvent(_key, _routeType));
        return Container();
      },
    );
  }

  Widget _buildBodyWithLoading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildBodyWithFailure(BuildContext context, GetSearchesFailureState state) {
    if(_routeType == ROUTE_TYPE_SEARCHES_ISSUE || _routeType == ROUTE_TYPE_SEARCHES_PULL){
      if(state.issues == null){
        return TryAgainWidget(
          code: state.errorCode,
          onTryPressed: () => context.read<SearchesBloc>().add(GetSearchesEvent(_key, _routeType)),
        );
      }
      return _buildSliverSearchesWithIssues(context, state.issues, state.hasMore);
    }else if(_routeType == ROUTE_TYPE_SEARCHES_USER || _routeType == ROUTE_TYPE_SEARCHES_ORG){
      if(state.users == null){
        return TryAgainWidget(
          code: state.errorCode,
          onTryPressed: () => context.read<SearchesBloc>().add(GetSearchesEvent(_key, _routeType)),
        );
      }
      return _buildSliverSearchesWithUsers(context, state.users, state.hasMore);
    }else{
      if(state.repos == null){
        return TryAgainWidget(
          code: state.errorCode,
          onTryPressed: () => context.read<SearchesBloc>().add(GetSearchesEvent(_key, _routeType)),
        );
      }
      return _buildSliverSearchesWithRepos(context, state.repos, state.hasMore);
    }
  }

  Widget _buildBodyWithSuccess(BuildContext context, GetSearchesSuccessState state) {
    if(_routeType == ROUTE_TYPE_SEARCHES_ISSUE || _routeType == ROUTE_TYPE_SEARCHES_PULL){
      return _buildSliverSearchesWithIssues(context, state.issues, state.hasMore);
    }else if(_routeType == ROUTE_TYPE_SEARCHES_USER || _routeType == ROUTE_TYPE_SEARCHES_ORG){
      return _buildSliverSearchesWithUsers(context, state.users, state.hasMore);
    }else{
      return _buildSliverSearchesWithRepos(context, state.repos, state.hasMore);
    }
  }

  Widget _buildSliverSearchesWithIssues(BuildContext context, List<Issue> issues, bool hasMore){
    if(CommonUtil.isListEmpty(issues)){
      return EmptyPageWidget(AppLocalizations.of(context).noSearched);
    }
    return CustomScrollView(
      slivers: [
        buildSliverListWithFooter(
          context,
          itemCount: issues.length,
          itemBuilder: (context, index){
            Issue issue = issues[index];
            bool isPulls = _routeType == ROUTE_TYPE_SEARCHES_PULL;
            Icon titleLeading = !isPulls ? Icon(
                Icons.error_outline_outlined,
                color: CommonUtil.isTextEmpty(issue.closedAt) ? Colors.green : Colors.redAccent
            ) : Icon(
                Icons.transform,
                color: CommonUtil.isTextEmpty(issue.closedAt) ? Colors.blue : Colors.redAccent
            );
            return CommonIssuesItem(
              titleLeading: titleLeading,
              title: '${issue.title} #${issue.number}',
              date: DateUtil.parseTime(context, issue.createdAt),
              body: issue.body,
              bodyTrailing: issue.comments > 0 ? CommonTextBox(issue.comments.toString()) : null,
              labels: issue.labels,
              onTap: () => WebViewRoute.push(
                context,
                url: issue.htmlUrl,
              ),
            );
          },
          hasMore: hasMore,
          onLoadMore: () => context.read<SearchesBloc>().getMoreSearches()
        ),
      ],
    );
  }

  Widget _buildSliverSearchesWithUsers(BuildContext context, List<Owner> users, bool hasMore){
    if(CommonUtil.isListEmpty(users)){
      return EmptyPageWidget(AppLocalizations.of(context).noSearched);
    }
    return CustomScrollView(
      slivers: [
        buildSliverListWithFooter(
          context,
          itemCount: users.length,
          itemBuilder: (context, index){
            Owner user = users[index];
            bool isOrgs = _routeType == ROUTE_TYPE_SEARCHES_ORG;
            return CommonOwnersItem(
              ownerAvatarUrl: user.avatarUrl,
              ownerLoginName: user.login,
              ownerDescription: user.description,
              onTap: () => ProfileRoute.push(
                context,
                name: user.login,
                routeType: !isOrgs ? ROUTE_TYPE_PROFILE_USER : ROUTE_TYPE_PROFILE_ORG
              )
            );
          },
          hasMore: hasMore,
          onLoadMore: () => context.read<SearchesBloc>().getMoreSearches()
        ),
      ],
    );
  }

  Widget _buildSliverSearchesWithRepos(BuildContext context, List<Repository> repos, bool hasMore){
    if(CommonUtil.isListEmpty(repos)){
      return EmptyPageWidget(AppLocalizations.of(context).noSearched);
    }
    return CustomScrollView(
      slivers: [
        buildSliverListWithFooter(
          context,
          itemCount: repos.length,
          itemBuilder: (context, index){
            Repository repo = repos[index];
            return CommonReposItem(
              ownerAvatarUrl: repo.owner.avatarUrl,
              ownerLoginName: repo.owner.login,
              repoName: repo.name,
              repoDescription: repo.description,
              stargazersCount: repo.stargazersCount,
              language: repo.language,
              onTap: () => RepoRoute.push(
                context,
                name: repo.owner.login,
                repoName: repo.name
              ),
            );
          },
          hasMore: hasMore,
          onLoadMore: () => context.read<SearchesBloc>().getMoreSearches()
        ),
      ],
    );
  }


}