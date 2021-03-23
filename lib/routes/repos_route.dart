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
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/custom_divider.dart';
import 'package:flutter_github_app/widgets/empty_page_widget.dart';
import 'package:flutter_github_app/widgets/rounded_image.dart';
import 'package:flutter_github_app/widgets/simple_chip.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class ReposRoute extends StatelessWidget with LoadMoreSliverListMixin{

  static const name = 'reposRoute';

  static route(){
    return BlocProvider(
      create: (_) => ReposBloc(),
      child: ReposRoute(),
    );
  }

  static Future push(BuildContext context, {
    String name,
    String repoName,
    int routeType
  }){
    return Navigator.of(context).pushNamed(ReposRoute.name, arguments: {
      KEY_NAME: name,
      KEY_REPO_NAME: repoName,
      KEY_ROUTE_TYPE: routeType
    });
  }

  String _name;
  String _repoName;
  int _routeType = ROUTE_TYPE_REPOS_USER;

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context).settings.arguments as Map;
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
      onRefresh: () => context.read<ReposBloc>().refreshRepos(_routeType),
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
    return Center(
      child: CircularProgressIndicator(),
    );
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

  Widget _buildSliverRepos(BuildContext context, List<Repository> repos, bool hasMore){
    if(CommonUtil.isListEmpty(repos)){
      return EmptyPageWidget(AppLocalizations.of(context).noRepos);
    }
    return CustomScrollView(
      slivers: [
        buildSliverListWithFooter(
          context,
          itemCount: repos.length,
          itemBuilder: (context, index){
            Repository repo = repos[index];
            return Ink(
              color: Theme.of(context).primaryColor,
              child: InkWell(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(_routeType == ROUTE_TYPE_REPOS_FORK)
                        TightListTile(
                          padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                          titlePadding: EdgeInsets.only(left: 10),
                          leading: RoundedImage.network(
                            repo.owner.avatarUrl,
                            width: 25,
                            height: 25,
                            radius: 6.0,
                          ),
                          title: Text(
                            repo.owner.login,
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.grey
                            ),
                          ),
                        ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Text(
                          repo.name,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 2, 15, 0),
                        child: MarkdownBody(
                          data: repo.description?? '',
                          extensionSet: md.ExtensionSet.gitHubWeb,
                        ),
                      ),
                      TightListTile(
                          padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                          leading: SimpleChip(
                            avatar: Icon(
                                Icons.star,
                                color: Colors.yellow
                            ),
                            label: Text(
                              CommonUtil.numToThousand(repo.stargazersCount),
                              style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  color: Colors.grey[600]
                              ),
                            ),
                          ),
                          title: Builder(builder: (context){
                            if(CommonUtil.isTextEmpty(repo.language)){
                              return Container();
                            }
                            return SimpleChip(
                              avatar: Icon(
                                Icons.fiber_manual_record,
                                size: 15,
                                color: Colors.brown,
                              ),
                              label: Text(
                                repo.language?? '',
                                style: Theme.of(context).textTheme.bodyText1.copyWith(
                                    color: Colors.grey[600]
                                ),
                              ),
                            );
                          })
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: CustomDivider(),
                      )
                    ],
                  ),
                  onTap: () => RepoRoute.push(
                      context,
                      name: repo.owner.login,
                      repoName: repo.name
                  )
              ),
            );
          },
          hasMore: hasMore,
          onLoadMore: () => context.read<ReposBloc>().getMoreRepos(_routeType)
        )
      ],
    );
  }

}