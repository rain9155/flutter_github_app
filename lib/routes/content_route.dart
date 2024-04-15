
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/blocs/content_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:flutter_github_app/widgets/common_action.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/empty_page_widget.dart';
import 'package:flutter_github_app/widgets/loading_widget.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ContentRoute extends StatelessWidget{

  static final name = 'ContentRoute';

  static route(){
    return BlocProvider(
      create: (_) => ContentBloc(),
      child: ContentRoute._(),
    );
  }

  static Future push(BuildContext context, {
    required String? repoName,
    required String? name,
    required String? path,
    required String? htmlUrl,
    required String? chosenBranch,
  }){
    return Navigator.of(context).pushNamed(ContentRoute.name, arguments: {
      KEY_NAME: name,
      KEY_REPO_NAME: repoName,
      KEY_CHOSEN_BRANCH: chosenBranch,
      KEY_PATH: path,
      KEY_URL: htmlUrl
    });
  }

  ContentRoute._();

  String? _name;
  String? _repoName;
  String? _path;
  String? _branch;
  String? _htmlUrl;

  @override
  Widget build(BuildContext context) {
    var argument = ModalRoute.of(context)!.settings.arguments as Map;
    _name = argument[KEY_NAME];
    _repoName = argument[KEY_REPO_NAME];
    _branch = argument[KEY_CHOSEN_BRANCH];
    _path = argument[KEY_PATH];
    _htmlUrl = argument[KEY_URL];
    return CommonScaffold(
      sliverHeaderBuilder: (context, _){
        return _buildSliverAppBar(context);
      },
      body: CommonUtil.isImgEng(_path) ? _buildImgBody() : _buildFileBody(),
      onRefresh: CommonUtil.isImgEng(_path) ? null : () => context.read<ContentBloc>().refreshContent(),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return CommonSliverAppBar(
        title: CommonTitle(
          CommonUtil.getFileName(_path!),
          titleAlign: TextAlign.right,
        ),
        actions: [
          CommonAction(
            icon: Icons.share_outlined,
            tooltip: AppLocalizations.of(context).share,
            onPressed: () => Share.share(_htmlUrl!),
          ),
          CommonAction(
            icon: Icons.open_in_browser_outlined,
            tooltip: AppLocalizations.of(context).browser,
            onPressed: () => launchUrl(Uri.parse(_htmlUrl!)),
          ),
        ],
      );
  }

  Widget _buildImgBody(){
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Center(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Image.network(
                  '$_htmlUrl?raw=true',
                  loadingBuilder: (context, child, _){
                    return LoadingWidget();
                  },
                  errorBuilder: (context, error, _){
                    LogUtil.printString(name, 'errorBuilder: error = $error');
                    return TryAgainWidget(
                      hint: AppLocalizations.of(context).loadFail,
                      onTryPressed: () => setState((){}),
                    );
                  },
                );
              }
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFileBody() {
    return BlocBuilder<ContentBloc, ContentState>(
      builder: (context, state){
        if(state is GettingContentState){
          return _buildBodyWithLoading(context);
        }
        if(state is GetContentFailureState){
          return _buildBodyWithFailure(context, state);
        }
        if(state is GetContentSuccessState){
          return _buildBodyWithSuccess(context, state);
        }
        context.read<ContentBloc>().add(GetContentEvent(_name, _repoName, _path, _branch));
        return Container();
      },
    );
  }

  Widget _buildBodyWithLoading(BuildContext context){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildBodyWithFailure(BuildContext context, GetContentFailureState state){
    if(state.content == null){
      return TryAgainWidget(
        code: state.errorCode,
        onTryPressed: () => context.read<ContentBloc>().add(GetContentEvent(_name, _repoName, _path, _branch)),
      );
    }
    return _buildSliverContents(context, state.content);
  }

  Widget _buildBodyWithSuccess(BuildContext context, GetContentSuccessState state){
    return _buildSliverContents(context, state.content);
  }

  Widget _buildSliverContents(BuildContext context, String? content){
    if(CommonUtil.isTextEmpty(content)){
      return EmptyPageWidget(AppLocalizations.of(context).nothing);
    }
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            color: Theme.of(context).primaryColor,
            child: Html(
              data: content,
              onLinkTap: (url, _, ___) => launchUrl(Uri.parse(url!)),
              extensions: [
                OnImageTapExtension(
                  onImageTap: (url, _, __) => launchUrl(Uri.parse(url!)),
                )
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(top: 15),
            color: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }

}