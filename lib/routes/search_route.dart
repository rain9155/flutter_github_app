
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/issue.dart';
import 'package:flutter_github_app/beans/owner.dart';
import 'package:flutter_github_app/beans/repository.dart';
import 'package:flutter_github_app/blocs/search_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/routes/profile_route.dart';
import 'package:flutter_github_app/routes/repo_route.dart';
import 'package:flutter_github_app/routes/searches_route.dart';
import 'package:flutter_github_app/routes/webview_route.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/date_util.dart';
import 'package:flutter_github_app/widgets/common_issues_item.dart';
import 'package:flutter_github_app/widgets/common_owners_item.dart';
import 'package:flutter_github_app/widgets/common_repos_item.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_text_box.dart';
import 'package:flutter_github_app/widgets/custom_divider.dart';
import 'package:flutter_github_app/widgets/custom_scroll_config.dart';
import 'package:flutter_github_app/widgets/empty_page_widget.dart';
import 'package:flutter_github_app/widgets/loading_widget.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';

class SearchRoute extends StatefulWidget{

  static final name = 'SearchRoute';

  static route(){
    return BlocProvider(
      create: (_) => SearchBloc(),
      child: SearchRoute._(),
    );
  }

  static Future push(BuildContext context){
    return Navigator.of(context).pushNamed(SearchRoute.name);
  }

  SearchRoute._();

  @override
  State createState() => _SearchRouteState();
}

class _SearchRouteState extends State<SearchRoute>{

  TextEditingController? _controller;
  FocusNode? _focusNode;
  String? _text;
  String? _key;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller!.addListener((){
      String newText = _controller!.text.trim();
      if(newText != _text){
        _text = newText;
        context.read<SearchBloc>().add(TextChangedEvent(_text!.length > 0));
      }
    });
    context.read<SearchBloc>().add(GetHistoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollConfiguration(
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody(){
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state){
        if(state is SearchingState){
          return _buildBodyWithSlivers(context, true, _buildSliverSearchLoading(context));
        }
        if(state is SearchFailureState){
          return _buildBodyWithSlivers(context, true, _buildSliverSearchError(context, state.errorCode));
        }
        if(state is SearchSuccessState){
          return _buildBodyWithSlivers(context, true, _buildSliverSearches(context, state));
        }
        if(state is ShowGuidesState){
          return _buildBodyWithSlivers(context, true, _buildSliverGuides(context));
        }
        if(state is ShowHistoriesState){
          return _buildBodyWithSlivers(context, false, _buildSliverHistories(context, state.histories));
        }
        return _buildBodyWithSlivers(context, false, _buildSliverEmpty(context));
      },
    );
  }

  Widget _buildBodyWithSlivers(BuildContext context, bool hasText, List<Widget> slivers){
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, hasText),
        ...slivers
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool hasText) {
    return CommonSliverAppBar(
      title: TextField(
        controller: _controller,
        autofocus: true,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        cursorColor: Theme.of(context).accentColor,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).search,
          hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
            color: Theme.of(context).disabledColor
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).dividerColor)
          ),
          focusedBorder:  UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).dividerColor)
          ),
          suffixIcon: !hasText ? null : IconButton(
            icon: Icon(
              Icons.clear,
              color: Theme.of(context).hintColor,
            ),
            onPressed: () => _controller!.clear()
          )
        ),
        onSubmitted: (value){
          _focusNode!.unfocus();
          _key = value.trim();
          context.read<SearchBloc>().add(SaveHistoryEvent(_key));
          context.read<SearchBloc>().add(StartSearchEvent(_key));
        },
      ),
    );
  }

  List<Widget> _buildSliverEmpty(BuildContext context, {bool isHistories = true}){
    return [
      SliverFillRemaining(
        child: EmptyPageWidget(
          isHistories ? AppLocalizations.of(context).searchHint : AppLocalizations.of(context).noSearched,
          subHint: isHistories ? AppLocalizations.of(context).searchSubHint : '',
        ),
      )
    ];
  }

  List<Widget> _buildSliverHistories(BuildContext context, List<String?> histories){
    if(CommonUtil.isListEmpty(histories)){
      return _buildSliverEmpty(context);
    }
    return [
      SliverToBoxAdapter(
        child: TightListTile(
          height: 60,
          padding: EdgeInsets.only(left: 15, right: 5),
          backgroundColor: Theme.of(context).primaryColor,
          leading: Text(
            AppLocalizations.of(context).recentSearches,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.w600
            ),
          ),
          trailing: TextButton(
            child: Text(
              AppLocalizations.of(context).clear.toUpperCase(),
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: Theme.of(context).accentColor
              ),
            ),
            onPressed: () => context.read<SearchBloc>().add(DeleteHistoriesEvent()),
          ),
        ),
      ),
      SliverFixedExtentList(
        itemExtent: 60,
        delegate: SliverChildBuilderDelegate(
          (context, index){
            String history = histories[index]!;
            return TightListTile(
              padding: EdgeInsets.only(left: 15, right: 5),
              backgroundColor: Theme.of(context).primaryColor,
              leading: Text(history),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: () => context.read<SearchBloc>().add(DeleteHistoryEvent(history)),
              ),
              onTap: (){
                _controller!.text = history;
                _controller!.selection = TextSelection.fromPosition(TextPosition(offset: history.length));
                context.read<SearchBloc>().add(SaveHistoryEvent(history));
              },
            );
          },
          childCount: histories.length
        ),
      )
    ];
  }

  List<Widget> _buildSliverGuides(BuildContext context){
    return [
      SliverFixedExtentList(
        itemExtent: 60,
        delegate: SliverChildListDelegate([
          TightListTile(
            padding: EdgeInsets.symmetric(horizontal: 15),
            backgroundColor: Theme.of(context).primaryColor,
            leading: Icon(Icons.receipt_outlined),
            title: Text(AppLocalizations.of(context).reposWith(_controller!.text)),
            onTap: (){
              String key = _controller!.text.trim();
              context.read<SearchBloc>().add(SaveHistoryEvent(key));
              SearchesRoute.push(
                context,
                key: key,
                routeType: ROUTE_TYPE_SEARCHES_REPO
              );
            },
          ),
          TightListTile(
            padding: EdgeInsets.symmetric(horizontal: 15),
            backgroundColor: Theme.of(context).primaryColor,
            leading: Icon(Icons.error_outline_outlined),
            title: Text(AppLocalizations.of(context).issuesWith(_controller!.text)),
            onTap: (){
              String key = _controller!.text.trim();
              context.read<SearchBloc>().add(SaveHistoryEvent(key));
              SearchesRoute.push(
                context,
                key: key,
                routeType: ROUTE_TYPE_SEARCHES_ISSUE
              );
            }
          ),
          TightListTile(
            padding: EdgeInsets.symmetric(horizontal: 15),
            backgroundColor: Theme.of(context).primaryColor,
            leading: Icon(Icons.transform_outlined),
            title: Text(AppLocalizations.of(context).pullsWith(_controller!.text)),
            onTap: (){
              String key = _controller!.text.trim();
              context.read<SearchBloc>().add(SaveHistoryEvent(key));
              SearchesRoute.push(
                context,
                key: key,
                routeType: ROUTE_TYPE_SEARCHES_PULL
              );
            }
          ),
          TightListTile(
            padding: EdgeInsets.symmetric(horizontal: 15),
            backgroundColor: Theme.of(context).primaryColor,
            leading: Icon(Icons.person_outline_outlined),
            title: Text(AppLocalizations.of(context).peopleWith(_controller!.text)),
            onTap: (){
              String key = _controller!.text.trim();
              context.read<SearchBloc>().add(SaveHistoryEvent(key));
              SearchesRoute.push(
                context,
                key: key,
                routeType: ROUTE_TYPE_SEARCHES_USER
              );
            }
          ),
          TightListTile(
            padding: EdgeInsets.symmetric(horizontal: 15),
            backgroundColor: Theme.of(context).primaryColor,
            leading: Icon(Icons.people_alt_outlined),
            title: Text(AppLocalizations.of(context).orgsWith(_controller!.text)),
            onTap: (){
              String key = _controller!.text.trim();
              context.read<SearchBloc>().add(SaveHistoryEvent(key));
              SearchesRoute.push(
                context,
                key: key,
                routeType: ROUTE_TYPE_SEARCHES_ORG
              );
            }
          ),
          TightListTile(
            padding: EdgeInsets.symmetric(horizontal: 15),
            backgroundColor: Theme.of(context).primaryColor,
            leading: Icon(Icons.arrow_forward_outlined),
            title: Text('${AppLocalizations.of(context).jumpTo} "${_controller!.text}"'),
            onTap: (){
              String key = _controller!.text.trim();
              context.read<SearchBloc>().add(SaveHistoryEvent(key));
              ProfileRoute.push(
                context,
                name: key,
                routeType: ROUTE_TYPE_PROFILE_USER
              );
            }
          ),
        ]),
      ),
      SliverToBoxAdapter(
        child: CustomDivider(bold: true),
      )
    ];
  }

  List<Widget> _buildSliverSearchLoading(BuildContext context){
    return [
      SliverFillRemaining(
        child: LoadingWidget(),
      )
    ];
  }

  List<Widget> _buildSliverSearchError(BuildContext context, int? code){
    return [
      SliverFillRemaining(
        child: TryAgainWidget(
          code: code,
          onTryPressed: () => context.read<SearchBloc>().add(StartSearchEvent(_key)),
        ),
      )
    ];
  }

  List<Widget> _buildSliverSearches(BuildContext context, SearchSuccessState state){
    if(CommonUtil.isListEmpty(state.repos)
        && CommonUtil.isListEmpty(state.pulls)
        && CommonUtil.isListEmpty(state.issues)
        && CommonUtil.isListEmpty(state.orgs)
        && CommonUtil.isListEmpty(state.users)
    ){
      return _buildSliverEmpty(context, isHistories: false);
    }
    return [
      if(!CommonUtil.isListEmpty(state.repos))
        ..._buildSliverSearchesWithRepos(context, state.repos!, state.totalReposCount!),
      if(!CommonUtil.isListEmpty(state.issues))
        ..._buildSliverSearchesWithIssues(context, state.issues!, state.totalIssuesCount!),
      if(!CommonUtil.isListEmpty(state.pulls))
        ..._buildSliverSearchesWithIssues(context, state.pulls!, state.totalPullsCount!, isPulls: true),
      if(!CommonUtil.isListEmpty(state.users))
        ..._buildSliverSearchesWithUsers(context, state.users!, state.totalUsersCount!),
      if(!CommonUtil.isListEmpty(state.orgs))
        ..._buildSliverSearchesWithUsers(context, state.orgs!, state.totalOrgsCount!, isOrgs: true),
    ];
  }

  List<Widget> _buildSliverSearchesWithRepos(BuildContext context, List<Repository> repos, int totalCount){
    return [
      SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.all(15),
          color: Theme.of(context).primaryColor,
          child: Text(
            AppLocalizations.of(context).repos,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.w600
            ),
          ),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index){
            Repository repo = repos[index];
            return CommonReposItem(
              ownerAvatarUrl: repo.owner!.avatarUrl,
              ownerLoginName: repo.owner!.login,
              repoName: repo.name,
              repoDescription: repo.description,
              stargazersCount: repo.stargazersCount,
              language: repo.language,
              showDivider: false,
              onTap: () => RepoRoute.push(
                context,
                name: repo.owner!.login,
                repoName: repo.name
              ),
            );
          },
          childCount: repos.length
        ),
      ),
      if(totalCount > repos.length)
        SliverToBoxAdapter(
          child: TightListTile(
            padding: EdgeInsets.all(15),
            backgroundColor: Theme.of(context).primaryColor,
            leading: Text(
              AppLocalizations.of(context).seeReposWith(CommonUtil.numToThousand(totalCount - repos.length)),
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.w600
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            onTap: () => SearchesRoute.push(
              context,
              key: _key,
              routeType: ROUTE_TYPE_SEARCHES_REPO
            ),
          )
        ),
      SliverToBoxAdapter(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: CustomDivider()
        )
      )
    ];
  }

  List<Widget> _buildSliverSearchesWithIssues(BuildContext context, List<Issue> issues, int totalCount, {bool isPulls = false}){
    return [
      SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.all(15),
          color: Theme.of(context).primaryColor,
          child: Text(
            !isPulls ? AppLocalizations.of(context).issues : AppLocalizations.of(context).pullRequests,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.w600
            ),
          ),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index){
            Issue issue = issues[index];
            Icon titleLeading = !isPulls ? Icon(
              Icons.error_outline_outlined,
              color: CommonUtil.isTextEmpty(issue.closedAt) ? Colors.green : Colors.redAccent
            ) : Icon(
              Icons.transform,
              color: CommonUtil.isTextEmpty(issue.closedAt) ? Colors.blue : Colors.redAccent
            );
            return CommonIssuesItem(
              showDivider: false,
              titleLeading: titleLeading,
              title: '${issue.title} #${issue.number}',
              date: DateUtil.parseTime(context, issue.createdAt!),
              body: issue.body,
              bodyTrailing: issue.comments! > 0 ? CommonTextBox(issue.comments.toString()) : null,
              labels: issue.labels,
              onTap: () => WebViewRoute.push(
                context,
                url: issue.htmlUrl,
              ),
            );
          },
          childCount: issues.length
        ),
      ),
      if(totalCount > issues.length)
        SliverToBoxAdapter(
          child: TightListTile(
            padding: EdgeInsets.all(15),
            backgroundColor: Theme.of(context).primaryColor,
            leading: Text(
              !isPulls ? AppLocalizations.of(context).seeIssuesWith(CommonUtil.numToThousand(totalCount - issues.length)) : AppLocalizations.of(context).seePullsWith(CommonUtil.numToThousand(totalCount - issues.length)),
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.w600
              ),
            ),
            trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey
            ),
            onTap: () => SearchesRoute.push(
              context,
              key: _key,
              routeType: !isPulls ? ROUTE_TYPE_SEARCHES_ISSUE : ROUTE_TYPE_SEARCHES_PULL
            ),
          ),
        ),
      SliverToBoxAdapter(
        child: Container(
            color: Theme.of(context).primaryColor,
            child: CustomDivider()
        )
      )
    ];
  }

  List<Widget> _buildSliverSearchesWithUsers(BuildContext context, List<Owner> users, int totalCount, {bool isOrgs = false}) {
    return [
      SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.all(15),
          color: Theme.of(context).primaryColor,
          child: Text(
            !isOrgs ? AppLocalizations.of(context).people : AppLocalizations.of(context).orgs,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.w600
            ),
          ),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index){
            Owner user = users[index];
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
          childCount: users.length
        ),
      ),
      if(totalCount > users.length)
        SliverToBoxAdapter(
          child: TightListTile(
            padding: EdgeInsets.all(15),
            backgroundColor: Theme.of(context).primaryColor,
            leading: Text(
              !isOrgs ? AppLocalizations.of(context).seePeopleWith(CommonUtil.numToThousand(totalCount - users.length)) : AppLocalizations.of(context).seeOrgsWith(CommonUtil.numToThousand(totalCount - users.length)),
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.w600
              ),
            ),
            trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey
            ),
            onTap: () => SearchesRoute.push(
                context,
                key: _key,
                routeType: !isOrgs ? ROUTE_TYPE_SEARCHES_USER : ROUTE_TYPE_SEARCHES_ORG
            ),
          )
        ),
      SliverToBoxAdapter(
        child: Container(
            color: Theme.of(context).primaryColor,
            child: CustomDivider()
        )
      )
    ];
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}