
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/owner.dart';
import 'package:flutter_github_app/blocs/owners_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/mixin/load_more_sliverlist_mixin.dart';
import 'package:flutter_github_app/routes/profile_route.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/widgets/common_owners_item.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/empty_page_widget.dart';
import 'package:flutter_github_app/widgets/loading_widget.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';

class OwnersRoute extends StatelessWidget with LoadMoreSliverListMixin{

  static final name = 'OwnersRoute';

  static route(){
    return BlocProvider(
      create: (_) => OwnersBloc(),
      child: OwnersRoute._(),
    );
  }

  OwnersRoute._();

  static Future push(BuildContext context, {
    String name,
    String repoName,
    int routeType
  }){
    return Navigator.of(context).pushNamed(OwnersRoute.name, arguments: {
      KEY_NAME: name,
      KEY_REPO_NAME: repoName,
      KEY_ROUTE_TYPE: routeType
    });
  }

  String _name;
  String _repoName;
  int _routeType = ROUTE_TYPE_OWNERS_ORG;

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
      onRefresh: () => context.read<OwnersBloc>().refreshOwners()
    );
  }

  Widget _buildSliverAppBar(BuildContext context){
    String getTitle(){
      switch(_routeType){
        case ROUTE_TYPE_OWNERS_FOLLOWER:
          return AppLocalizations.of(context).follower;
        case ROUTE_TYPE_OWNERS_FOLLOWING:
          return AppLocalizations.of(context).follow;
        case ROUTE_TYPE_OWNERS_MEMBER:
          return AppLocalizations.of(context).members;
        case ROUTE_TYPE_OWNERS_STARGAZER:
          return AppLocalizations.of(context).stargazers;
        case ROUTE_TYPE_OWNERS_WATCHER:
          return AppLocalizations.of(context).watchers;
        default:
          return AppLocalizations.of(context).orgs;
      }
    }
    return CommonSliverAppBar(
      title: CommonTitle(getTitle()),
    );
  }

  Widget _buildBody(){
    return BlocBuilder<OwnersBloc, OwnersState>(
      builder: (context, state){
        if(state is GettingOwnersState){
          return _buildBodyWithLoading(context);
        }
        if(state is GetOwnersFailureState){
          return _buildBodyWithFailure(context, state);
        }
        if(state is GetOwnersSuccessState){
          return _buildBodyWithSuccess(context, state);
        }
        context.read<OwnersBloc>().add(GetOwnersEvent(_name, _repoName, _routeType));
        return Container();
      },
    );
  }

  Widget _buildBodyWithLoading(BuildContext context){
    return LoadingWidget();
  }

  Widget _buildBodyWithFailure(BuildContext context, GetOwnersFailureState state){
    if(state.owners == null){
      return TryAgainWidget(
        code: state.errorCode,
        onTryPressed: () => context.read<OwnersBloc>().add(GetOwnersEvent(_name, _repoName, _routeType)),
      );
    }
    return _buildSliverOwners(context, state.owners, state.hasMore);
  }

  Widget _buildBodyWithSuccess(BuildContext context, GetOwnersSuccessState state){
    return _buildSliverOwners(context, state.owners, state.hasMore);
  }

  Widget _buildSliverOwners(BuildContext context, List<Owner> owners, bool hasMore){
    if(CommonUtil.isListEmpty(owners)){
      return EmptyPageWidget(AppLocalizations.of(context).nothing);
    }
    return CustomScrollView(
      slivers: [
        buildSliverListWithFooter(
          context,
          itemCount: owners.length,
          itemBuilder: (context, index){
            Owner owner = owners[index];
            return CommonOwnersItem(
              ownerAvatarUrl: owner.avatarUrl,
              ownerLoginName: owner.login,
              ownerDescription: owner.description,
              onTap: () => ProfileRoute.push(
                context,
                name: owner.login,
                routeType: _routeType == ROUTE_TYPE_OWNERS_ORG ? ROUTE_TYPE_PROFILE_ORG : ROUTE_TYPE_PROFILE_USER
              )
            );
          },
          hasMore: hasMore,
          onLoadMore: () => context.read<OwnersBloc>().getMoreOwners()
        )
      ],
    );
  }
}