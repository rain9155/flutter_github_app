
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/content.dart';
import 'package:flutter_github_app/blocs/contents_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/routes/all_route.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/custom_divider.dart';
import 'package:flutter_github_app/widgets/empty_page_widget.dart';
import 'package:flutter_github_app/widgets/loading_widget.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';

import 'content_route.dart';

class ContentsRoute extends StatelessWidget{

  static final name = 'ContentsRoute';

  static route(){
    return BlocProvider(
      create: (_) => ContentsBloc(),
      child: ContentsRoute._(),
    );
  }

  static Future push(BuildContext context, {
    required String? name,
    required String? repoName,
    required String? chosenBranch,
    String? path
  }){
    return Navigator.of(context).pushNamed(ContentsRoute.name, arguments: {
      KEY_NAME: name,
      KEY_REPO_NAME: repoName,
      KEY_CHOSEN_BRANCH: chosenBranch,
      KEY_PATH: path
    });
  }

  ContentsRoute._();

  String? _name;
  String? _repoName;
  String? _path;
  String? _branch;

  @override
  Widget build(BuildContext context) {
    var argument = ModalRoute.of(context)!.settings.arguments as Map;
    _name = argument[KEY_NAME];
    _repoName = argument[KEY_REPO_NAME];
    _branch = argument[KEY_CHOSEN_BRANCH];
    _path = argument[KEY_PATH];
    return CommonScaffold(
      sliverHeaderBuilder: (context, _){
        return CommonSliverAppBar(
          title:  CommonTitle(_path?? AppLocalizations.of(context).files),
        );
      },
      body: _buildBody(),
      onRefresh: () => context.read<ContentsBloc>().refreshContents(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<ContentsBloc, ContentsState>(
      builder: (context, state){
        if(state is GettingContentsState){
          return _buildBodyWithLoading(context);
        }
        if(state is GetContentsFailureState){
          return _buildBodyWithFailure(context, state);
        }
        if(state is GetContentsSuccessState){
          return _buildBodyWithSuccess(context, state);
        }
        context.read<ContentsBloc>().add(GetContentsEvent(_name, _repoName, _path, _branch));
        return Container();
      },
    );
  }
  
  Widget _buildBodyWithLoading(BuildContext context){
    return LoadingWidget();
  }

  Widget _buildBodyWithFailure(BuildContext context, GetContentsFailureState state){
    if(state.contents == null){
      return TryAgainWidget(
        code: state.errorCode,
        onTryPressed: () => context.read<ContentsBloc>().add(GetContentsEvent(_name, _repoName, _path, _branch)),
      );
    }
    return _buildSliverContents(context, state.contents);
  }

  Widget _buildBodyWithSuccess(BuildContext context, GetContentsSuccessState state){
    return _buildSliverContents(context, state.contents);
  }

  Widget _buildSliverContents(BuildContext context, List<Content>? contents){
    if(CommonUtil.isListEmpty(contents)){
      return EmptyPageWidget(AppLocalizations.of(context).noFiles);
    }
    return CustomScrollView(
      slivers: [
        SliverFixedExtentList(
          itemExtent: 60,
          delegate: SliverChildBuilderDelegate(
            (context, index){
              Content content = contents![index];
              return TightListTile(
                padding: EdgeInsets.symmetric(horizontal: 15),
                titlePadding: EdgeInsets.only(left: 10),
                backgroundColor: Theme.of(context).primaryColor,
                leading: Icon(
                  content.type == CONTENT_TYPE_DIR
                      ? Icons.folder
                      : content.type == CONTENT_TYPE_FILE
                          ? Icons.insert_drive_file_outlined
                          : Icons.insert_link_outlined,
                  color: content.type == CONTENT_TYPE_DIR
                      ? Colors.blue[300]
                      : Colors.grey,
                  size: 26,
                ),
                title: Text(content.name!),
                onTap: (){
                  if(content.type == CONTENT_TYPE_DIR){
                    ContentsRoute.push(
                      context,
                      name: _name,
                      repoName: _repoName,
                      chosenBranch: _branch,
                      path: content.path
                    );
                  }else if(content.type == CONTENT_TYPE_FILE && !CommonUtil.isImgEng(content.path)){
                    ContentRoute.push(
                      context,
                      name: _name,
                      repoName: _repoName,
                      chosenBranch: _branch,
                      path: content.path,
                      htmlUrl: content.htmlUrl
                    );
                  }else{
                    WebViewRoute.push(
                      context,
                      title: CommonUtil.getFileName(content.path!),
                      url: content.htmlUrl
                    );
                  }
                },
              );
            },
            childCount: contents!.length
          ),
        ),
        SliverToBoxAdapter(
         child: CustomDivider(bold: true),
        )
      ],
    );
  }
}