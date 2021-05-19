
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/repository.dart';
import 'package:flutter_github_app/blocs/repo_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/cubits/branch_cubit.dart';
import 'package:flutter_github_app/cubits/readme_cubit.dart';
import 'package:flutter_github_app/cubits/star_cubit.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/routes/all_route.dart';
import 'package:flutter_github_app/routes/branches_route.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/toast_util.dart';
import 'package:flutter_github_app/widgets/common_action.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/custom_divider.dart';
import 'package:flutter_github_app/widgets/loading_widget.dart';
import 'package:flutter_github_app/widgets/rounded_image.dart';
import 'package:flutter_github_app/widgets/simple_chip.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class RepoRoute extends StatelessWidget{

  static final name = 'RepoRoute';

  static route(){
    return BlocProvider(
      create: (_) => RepoBloc(),
      child: RepoRoute._(),
    );
  }

  static Future push(BuildContext context, {
    String? name,
    String? repoName,
    String? repoUrl
  }){
    return Navigator.of(context).pushNamed(RepoRoute.name, arguments: {
      KEY_NAME: name,
      KEY_REPO_NAME: repoName,
      KEY_URL: repoUrl
    });
  }

  RepoRoute._();

  String? _url;
  String? _name;
  String? _repoName;
  String? _htmlUrl;
  String? _chosenBranch;

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments as Map;
    _name = arguments[KEY_NAME];
    _repoName = arguments[KEY_REPO_NAME];
    _url = arguments[KEY_URL];
    return CommonScaffold(
      sliverHeaderBuilder: (context, _){
        return _buildSliverAppBar(context);
      },
      body: _buildBody(),
      onRefresh: () => context.read<RepoBloc>().refreshRepo()
    );
  }

  Widget _buildSliverAppBar(BuildContext context){
    return CommonSliverAppBar(
      actions: [
        CommonAction(
          icon: Icons.share_outlined,
          tooltip: AppLocalizations.of(context).share,
          onPressed: (){
            if(CommonUtil.isTextEmpty(_htmlUrl)){
              ToastUtil.showSnackBar(context, msg: AppLocalizations.of(context).loading);
              return;
            }
            Share.share(_htmlUrl!);
          }
        ),
        CommonAction(
          icon: Icons.open_in_browser_outlined,
          tooltip: AppLocalizations.of(context).browser,
          onPressed: (){
            if(CommonUtil.isTextEmpty(_htmlUrl)){
              ToastUtil.showSnackBar(context, msg: AppLocalizations.of(context).loading);
              return;
            }
            launch(_htmlUrl!);
          }
        ),
        CommonAction(
          icon: Icons.add_circle_outline_outlined,
          tooltip: AppLocalizations.of(context).createIssue,
          onPressed: (){
            if(CommonUtil.isTextEmpty(_name) || CommonUtil.isTextEmpty(_repoName)){
              ToastUtil.showSnackBar(context, msg: AppLocalizations.of(context).loading);
              return;
            }
            CreateIssueRoute.push(
              context,
              name: _name,
              repoName: _repoName
            );
          },
        )
      ],
    );
  }

  Widget _buildBody(){
    return BlocBuilder<RepoBloc, RepoState>(
      builder: (context, state){
        if(state is GettingRepoState){
          return _buildBodyWithLoading(context);
        }
        if(state is GetRepoFailureState){
          return _buildBodyWithFailure(context, state);
        }
        if(state is GetRepoSuccessState){
          return _buildBodyWithSuccess(context, state);
        }
        context.read<RepoBloc>().add(GetRepoEvent(_url, _name, _repoName));
        return Container();
      }
    );
  }

  Widget _buildBodyWithLoading(BuildContext context) {
    return LoadingWidget();
  }

  Widget _buildBodyWithFailure(BuildContext context, GetRepoFailureState state) {
    if(state.repository == null || state.isStarred == null){
      return TryAgainWidget(
        code: state.errorCode,
        onTryPressed: () => context.read<RepoBloc>().add(GetRepoEvent(_url, _name, _repoName)),
      );
    }
    return _buildSliverRepo(context, state.repository!, state.isStarred, state.branch, state.readmd);
  }

  Widget _buildBodyWithSuccess(BuildContext context, GetRepoSuccessState state) {
    return _buildSliverRepo(context, state.repository!, state.isStarred, state.branch, state.readmd);
  }

  Widget _buildSliverRepo(BuildContext context, Repository repository, bool? isStarred, String? chosenBranch, String? readme){
    _name = repository.owner!.login;
    _repoName = repository.name;
    _htmlUrl = repository.htmlUrl;
    _chosenBranch = chosenBranch;
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
              Material(
                color: Theme.of(context).primaryColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TightListTile(
                        padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                        titlePadding: EdgeInsets.only(left: 10),
                        showSplash: false,
                        leading: RoundedImage.network(
                          repository.owner!.avatarUrl!,
                          width: 25,
                          height: 25,
                          radius: 6.0,
                        ),
                        title: Text(
                          repository.owner!.login!,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.grey
                          ),
                        ),
                        onTap: () => ProfileRoute.push(
                          context,
                          name: repository.owner!.login,
                          routeType: ROUTE_TYPE_PROFILE_USER
                        )
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                        child: Text(
                          repository.name!,
                          style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 30
                          ),
                        )
                    ),
                    if(!CommonUtil.isTextEmpty(repository.description))
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                        child: MarkdownBody(
                          data: repository.description!,
                          extensionSet: md.ExtensionSet.gitHubWeb,
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Wrap(
                        children: [
                          SimpleChip(
                            radius: 50,
                            avatar: Icon(
                              Icons.star_border_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                            label: Text('${CommonUtil.numToThousand(repository.stargazersCount)} ${AppLocalizations.of(context).stars}'),
                            onTap: () => OwnersRoute.push(
                                context,
                                name: repository.owner!.login,
                                repoName: repository.name,
                                routeType: ROUTE_TYPE_OWNERS_STARGAZER
                            ),
                          ),
                          SizedBox(width: 10),
                          SimpleChip(
                            radius: 50,
                            avatar: Icon(
                              Icons.alt_route_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                            label: Text('${CommonUtil.numToThousand(repository.forksCount)} ${AppLocalizations.of(context).forks}'),
                            onTap: () => ReposRoute.push(
                                context,
                                name: repository.owner!.login,
                                repoName: repository.name,
                                routeType: ROUTE_TYPE_REPOS_FORK
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
                      width: MediaQuery.of(context).size.width - 50,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: BlocBuilder<StarCubit, StarState>(
                              bloc: context.read<RepoBloc>().starCubit,
                              builder: (context, state){
                                if(state is StarringRepoState){
                                  return SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: LoadingWidget(isScroll: false)
                                  );
                                }
                                if(state is StarRepoResultState){
                                  isStarred = state.isStarred;
                                }
                                return SimpleChip(
                                  avatar: Icon(
                                    isStarred! ? Icons.star : Icons.star_border_outlined,
                                    color: isStarred! ? Colors.yellow : Theme.of(context).accentColor,
                                    size: 20,
                                  ),
                                  label: Text(
                                    isStarred! ? AppLocalizations.of(context).starred.toUpperCase() : AppLocalizations.of(context).star.toUpperCase(),
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                        color: isStarred! ? Theme.of(context).textTheme.bodyText1!.color : Theme.of(context).accentColor
                                    ),
                                  ),
                                  gap: 6,
                                );
                              }
                          ),
                          onPressed: () => context.read<RepoBloc>().add(StarRepoEvent(!isStarred!))
                      ),
                    ),
                  ],
                ),
              ),
              CustomDivider()
            ])
        ),
        SliverList(
            delegate: SliverChildListDelegate([
              TightListTile(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                backgroundColor: Theme.of(context).primaryColor,
                leading: Icon(
                    Icons.error,
                    color: Colors.green
                ),
                title: Text(AppLocalizations.of(context).issues),
                onTap: () => IssuesRoute.push(
                  context,
                  name: repository.owner!.login,
                  repoName: repository.name,
                  routeType: ROUTE_TYPE_ISSUES_REPO
                ),
              ),
              TightListTile(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                backgroundColor: Theme.of(context).primaryColor,
                leading: Icon(
                  Icons.transform,
                  color: Colors.blue,
                ),
                title: Text(AppLocalizations.of(context).pullRequests),
                onTap: () => PullsRoute.push(
                  context,
                  name: repository.owner!.login,
                  repoName: repository.name
                ),
              ),
              TightListTile(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                backgroundColor: Theme.of(context).primaryColor,
                leading: Icon(
                  Icons.remove_red_eye,
                  color: Colors.orange,
                ),
                title: Text(AppLocalizations.of(context).watchers),
                onTap: () => OwnersRoute.push(
                    context,
                    name: repository.owner!.login,
                    repoName: repository.name,
                    routeType: ROUTE_TYPE_OWNERS_WATCHER
                ),
              ),
              if(repository.license != null)
                TightListTile(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  backgroundColor: Theme.of(context).primaryColor,
                  leading: Icon(
                    Icons.insert_drive_file,
                    color: Colors.red,
                  ),
                  title: Text(AppLocalizations.of(context).license),
                  onTap: () => LicenseRoute.push(
                    context,
                    key: repository.license!.key,
                    name: repository.license!.name,
                  ),
                ),
              CustomDivider()
            ])
        ),
        SliverList(
            delegate: SliverChildListDelegate([
              TightListTile(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                backgroundColor: Theme.of(context).primaryColor,
                leading: Icon(
                  Icons.linear_scale,
                  color: Colors.grey,
                  size: 16,
                ),
                title: BlocBuilder<BranchCubit, BranchState>(
                  bloc: context.read<RepoBloc>().branchCubit,
                  builder: (context, state){
                    if(state is ChangeBranchResultState){
                      _chosenBranch = state.chosenBranch;
                    }
                    return Text(
                      _chosenBranch!,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Colors.grey
                      ),
                    );
                  },
                ),
                trailing: Text(
                  AppLocalizations.of(context).change.toUpperCase(),
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: Theme.of(context).accentColor
                  ),
                ),
                titlePadding: EdgeInsets.only(left: 12),
                onTap: () async{
                  var branch = await BranchesRoute.push(
                      context,
                      name: repository.owner!.login,
                      repoName: repository.name,
                      chosenBranch: _chosenBranch,
                      defaultBranch: repository.defaultBranch
                  );
                  context.read<RepoBloc>().add(ChangeBranchEvent(branch));
                },
              ),
              TightListTile(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(AppLocalizations.of(context).browseCode),
                onTap: () => ContentsRoute.push(
                  context,
                  name: repository.owner!.login,
                  repoName: repository.name,
                  chosenBranch: _chosenBranch,
                ),
              ),
              TightListTile(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(AppLocalizations.of(context).commits),
                onTap: () => CommitsRoute.push(
                    context,
                    name: repository.owner!.login,
                    repoName: repository.name,
                    branch: _chosenBranch
                ),
              ),
              CustomDivider(bold: true)
            ])
        ),
        SliverToBoxAdapter(
          child: BlocBuilder<ReadmeCubit, ReadmeState>(
            bloc: context.read<RepoBloc>().readmeCubit,
            builder: (context, state){
              if(state is UpdatingReadmeState){
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: LoadingWidget(isScroll: false),
                );
              }
              if(state is UpdateReadmeResultState){
                readme = state.readme;
              }
              if(readme == null){
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: TryAgainWidget(
                    isScroll: false,
                    hint: AppLocalizations.of(context).updateReadmeFail,
                    onTryPressed: () => context.read<RepoBloc>().add(UpdateReadmeEvent()),
                  ),
                );
              }else if(CommonUtil.isTextEmpty(readme)){
                return Container();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.all(15),
                    color: Theme.of(context).primaryColor,
                    child: MarkdownBody(
                      data: readme!,
                      extensionSet: md.ExtensionSet.gitHubWeb,
                      onTapLink: (text, href, _) => launch(href!),
                    ),
                  ),
                  CustomDivider(bold: true),
                  SizedBox(height: 15),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

}