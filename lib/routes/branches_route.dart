
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/branch.dart';
import 'package:flutter_github_app/blocs/branches_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/mixin/load_more_sliverlist_mixin.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_text_box.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/empty_page_widget.dart';
import 'package:flutter_github_app/widgets/loading_widget.dart';
import 'package:flutter_github_app/widgets/simple_chip.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';

class BranchesRoute extends StatelessWidget with LoadMoreSliverListMixin{

  static const name = 'BranchesRoute';

  static route(){
    return BlocProvider(
      create: (_) => BranchesBloc(),
      child: BranchesRoute._(),
    );
  }

  static Future push(BuildContext context, {
    @required String name,
    @required String repoName,
    @required String chosenBranch,
    @required String defaultBranch
  }){
    return Navigator.of(context).pushNamed(BranchesRoute.name, arguments: {
      KEY_NAME: name,
      KEY_REPO_NAME: repoName,
      KEY_DEFAULT_BRANCH: defaultBranch,
      KEY_CHOSEN_BRANCH: chosenBranch
    });
  }

  BranchesRoute._();

  String _name;
  String _repoName;
  String _chosenBranch;
  String _defaultBranch;

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context).settings.arguments as Map;
    _name = arguments[KEY_NAME];
    _repoName = arguments[KEY_REPO_NAME];
    _chosenBranch = arguments[KEY_CHOSEN_BRANCH];
    _defaultBranch = arguments[KEY_DEFAULT_BRANCH];
    return CommonScaffold(
      sliverHeaderBuilder: (context, _){
        return CommonSliverAppBar(
          title: CommonTitle(AppLocalizations.of(context).branches),
        );
      },
      body: _buildBody(),
      onRefresh: () => context.read<BranchesBloc>().refreshBranches()
    );
  }

  Widget _buildBody(){
    return BlocBuilder<BranchesBloc, BranchesState>(
      builder: (context, state){
        if(state is GettingBranchesState){
          return _buildBodyWithLoading(context);
        }
        if(state is GetBranchesFailureState){
          return _buildBodyWithFailure(context, state);
        }
        if(state is GetBranchesSuccessState){
          return _buildBodyWithSuccess(context, state);
        }
        context.read<BranchesBloc>().add(GetBranchesEvent(_name, _repoName));
        return Container();
      }
    );
  }

  Widget _buildBodyWithLoading(BuildContext context) {
    return LoadingWidget();
  }

  Widget _buildBodyWithFailure(BuildContext context, GetBranchesFailureState state) {
    if(state.branches == null){
      return TryAgainWidget(
        code: state.errorCode,
        onTryPressed: () => context.read<BranchesBloc>().add(GetBranchesEvent(_name, _repoName)),
      );
    }
    return _buildSliverBranches(context, state.branches, state.hasMore);
  }

  Widget _buildBodyWithSuccess(BuildContext context, GetBranchesSuccessState state) {
    return _buildSliverBranches(context, state.branches, state.hasMore);
  }

  Widget _buildSliverBranches(BuildContext context, List<Branch> branches, bool hasMore){
    if(CommonUtil.isListEmpty(branches)){
      return EmptyPageWidget(AppLocalizations.of(context).nothing);
    }
    return CustomScrollView(
      slivers: [
        buildSliverListWithFooter(
            context,
            itemCount: branches.length,
            itemBuilder: (context, index){
              Branch branch = branches[index];
              return TightListTile(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                titlePadding: EdgeInsets.only(right: 15),
                title: SimpleChip(
                  gap: 10,
                  avatar: Text(branch.name),
                  label: branch.name != _defaultBranch ? null : CommonTextBox(AppLocalizations.of(context).defaultValue),
                ),
                trailing: branch.name != _chosenBranch ? null : Icon(
                  Icons.check_circle_rounded,
                  color: Theme.of(context).accentColor,
                  size: 28,
                ),
                onTap: () => Navigator.of(context).pop(branch.name),
              );
            },
            hasMore: hasMore,
            onLoadMore: () => context.read<BranchesBloc>().getMoreBranches()
        )
      ],
    );
  }


}