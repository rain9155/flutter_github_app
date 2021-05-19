import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/repository.dart';
import 'package:flutter_github_app/blocs/repos_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/mixin/load_more_sliverlist_mixin.dart';
import 'package:flutter_github_app/routes/repo_route.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/widgets/common_repos_item.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/empty_page_widget.dart';
import 'package:flutter_github_app/widgets/loading_widget.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';

class ReposRoute extends StatelessWidget with LoadMoreSliverListMixin{

  static final name = 'ReposRoute';

  static route(){
    return BlocProvider(
      create: (_) => ReposBloc(),
      child: ReposRoute._(),
    );
  }

  static Future push(BuildContext context, {
    String? name,
    String? repoName,
    int? routeType
  }){
    return Navigator.of(context).pushNamed(ReposRoute.name, arguments: {
      KEY_NAME: name,
      KEY_REPO_NAME: repoName,
      KEY_ROUTE_TYPE: routeType
    });
  }

  ReposRoute._();

  String? _name;
  String? _repoName;
  int? _routeType = ROUTE_TYPE_REPOS_USER;

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments as Map?;
    if(arguments != null){
      _name = arguments[KEY_NAME];
      _repoName = arguments[KEY_REPO_NAME];
      _routeType = arguments[KEY_ROUTE_TYPE];
    }
    return CommonScaffold(
      sliverHeaderBuilder: (context, _){
        return _buildSliverAppBar(context);
      },
      body: _buildBody(),
      onRefresh: () => context.read<ReposBloc>().refreshRepos(),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    String getTitle(){
      switch(_routeType){
        case ROUTE_TYPE_REPOS_WATCHING:
          return AppLocalizations.of(context).watching;
        case ROUTE_TYPE_REPOS_STARRED:
          return AppLocalizations.of(context).starred;
        case ROUTE_TYPE_REPOS_FORK:
          return AppLocalizations.of(context).fork;
        default:
          return AppLocalizations.of(context).repos;
      }
    }
    return CommonSliverAppBar(
        title:CommonTitle(getTitle())
    );
  }

  Widget _buildBody(){
    return BlocBuilder<ReposBloc, ReposState>(
      builder: (context, state){
        if(state is GettingReposState){
          return _buildBodyWithLoading(context);
        }
        if(state is GetReposFailureState){
          return _buildBodyWithFailure(context, state);
        }
        if(state is GetReposSuccessState){
          return _buildBodyWithSuccess(context, state);
        }
        context.read<ReposBloc>().add(GetReposEvent(_name, _repoName, _routeType));
        return Container();
      }
    );
  }

  Widget _buildBodyWithLoading(BuildContext context){
    return LoadingWidget();
  }

  Widget _buildBodyWithFailure(BuildContext context, GetReposFailureState state){
    if(state.repositories == null){
      return TryAgainWidget(
        code: state.errorCode,
        onTryPressed: () => context.read<ReposBloc>().add(GetReposEvent( _name, _repoName, _routeType)),
      );
    }
    return _buildSliverRepos(context, state.repositories, state.hasMore);
  }

  Widget _buildBodyWithSuccess(BuildContext context, GetReposSuccessState state){
    return _buildSliverRepos(context, state.repositories, state.hasMore);
  }

  Widget _buildSliverRepos(BuildContext context, List<Repository>? repos, bool hasMore){
    if(CommonUtil.isListEmpty(repos)){
      return EmptyPageWidget(AppLocalizations.of(context).noRepos);
    }
    return CustomScrollView(
      slivers: [
        buildSliverListWithFooter(
          context,
          itemCount: repos!.length,
          itemBuilder: (context, index){
            Repository repo = repos[index];
            return CommonReposItem(
              ownerAvatarUrl: _routeType == ROUTE_TYPE_REPOS_FORK ? repo.owner!.avatarUrl : null,
              ownerLoginName:  _routeType == ROUTE_TYPE_REPOS_FORK ? repo.owner!.login : null,
              repoName: repo.name,
              repoDescription: repo.description,
              stargazersCount: repo.stargazersCount,
              language: repo.language,
              onTap: () => RepoRoute.push(
                context,
                name: repo.owner!.login,
                repoName: repo.name
              )
            );
          },
          hasMore: hasMore,
          onLoadMore: () => context.read<ReposBloc>().getMoreRepos()
        )
      ],
    );
  }

}