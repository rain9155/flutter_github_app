
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/event.dart';
import 'package:flutter_github_app/beans/profile.dart';
import 'package:flutter_github_app/blocs/profile_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/cubits/follow_cubit.dart';
import 'package:flutter_github_app/cubits/user_cubit.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/routes/all_route.dart';
import 'package:flutter_github_app/routes/owners_route.dart';
import 'package:flutter_github_app/routes/repos_route.dart';
import 'package:flutter_github_app/routes/settings_route.dart';
import 'package:flutter_github_app/mixin/load_more_sliverlist_mixin.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/date_util.dart';
import 'package:flutter_github_app/utils/toast_util.dart';
import 'package:flutter_github_app/widgets/common_action.dart';
import 'package:flutter_github_app/widgets/common_events_item.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/custom_divider.dart';
import 'package:flutter_github_app/widgets/loading_widget.dart';
import 'package:flutter_github_app/widgets/rounded_image.dart';
import 'package:flutter_github_app/widgets/simple_chip.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget{

  static page(int pageType){
    return BlocProvider(
      create: (context) => ProfileBloc(BlocProvider.of<UserCubit>(context)),
      child: ProfilePage._(pageType),
    );
  }

  ProfilePage._(this.pageType): assert(pageType != null);

  int pageType;

  @override
  _ProfilePageState createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin, LoadMoreSliverListMixin{

  String _htmlUrl;
  String _name;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var arguments = ModalRoute.of(context).settings.arguments as Map;
    if(arguments != null){
      _name = arguments[KEY_NAME];
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CommonScaffold(
      includeScaffold: false,
      sliverHeaderBuilder: (context, _){
        return _buildSliverAppBar(context);
      },
      body: _buildBody(),
      onRefresh: () => context.read<ProfileBloc>().refreshProfile()
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return CommonSliverAppBar(
      showLeading: false,
      title: CommonUtil.isTextEmpty(_name) ? CommonTitle(AppLocalizations.of(context).profile) : null,
      actions: [
        CommonAction(
            icon: Icons.share_outlined,
            tooltip: AppLocalizations.of(context).share,
            onPressed: (){
              if(CommonUtil.isTextEmpty(_htmlUrl)){
                ToastUtil.showSnackBar(context, msg: AppLocalizations.of(context).loading);
                return;
              }
              Share.share(_htmlUrl);
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
              launch(_htmlUrl);
            }
        ),
        if(CommonUtil.isTextEmpty(_name))
          CommonAction(
              icon: Icons.settings_outlined,
              tooltip: AppLocalizations.of(context).settings,
              onPressed: () => SettingsRoute.push(context)
          )
      ]
    );
  }

  Widget _buildBody() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state){
        if(state is GettingProfileState){
          return _buildBodyWithLoading(context);
        }
        if(state is GetProfileFailureState){
          return _buildBodyWithFailure(context, state);
        }
        if(state is GetProfileSuccessState){
          return _buildBodyWithSuccess(context, state);
        }
        context.read<ProfileBloc>().add(GetProfileEvent(_name, widget.pageType));
        return Container();
      },
    );
  }

  Widget _buildBodyWithLoading(BuildContext context){
    return LoadingWidget();
  }

  Widget _buildBodyWithFailure(BuildContext context, GetProfileFailureState state){
    if(state.profile == null || state.events == null){
      return TryAgainWidget(
        code: state.errorCode,
        onTryPressed: () => context.read<ProfileBloc>().add(GetProfileEvent(_name, widget.pageType)),
      );
    }
    return CustomScrollView(
      slivers: [
        ...?_buildSliverProfile(context, state.profile, state.isFollowing),
        ...?_buildSliverEvents(context, state.events, state.hasMore)
      ],
    );
  }

  Widget _buildBodyWithSuccess(BuildContext context, GetProfileSuccessState state){
    return CustomScrollView(
      slivers: [
        ...?_buildSliverProfile(context, state.profile, state.isFollowing),
        ...?_buildSliverEvents(context, state.events, state.hasMore)
      ],
    );
  }

  List<Widget> _buildSliverProfile(BuildContext context, Profile profile, bool isFollowing){
    _htmlUrl = profile.htmlUrl;
    return [
      SliverList(
        delegate: SliverChildListDelegate([
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                RoundedImage.network(
                  profile.avatarUrl,
                  width: 65,
                  height: 65,
                  radius: 8.0,
                ),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(!CommonUtil.isTextEmpty(profile.name))
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 120),
                          child: Text(
                            profile.name,
                            style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      Text(
                        profile.login,
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Colors.grey
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if(!CommonUtil.isTextEmpty(profile.bio) || !CommonUtil.isTextEmpty(profile.description))
            Container(
                padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                color: Theme.of(context).primaryColor,
                child: Text(
                    profile.bio?? profile.description,
                    style: Theme.of(context).textTheme.subtitle1
                )
            ),
          if(!CommonUtil.isTextEmpty(profile.location))
            Container(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            color: Theme.of(context).primaryColor,
            child: SimpleChip(
              avatar: Icon(
                Icons.location_on_outlined,
                size: 20,
                color: Colors.grey
              ),
              label: Text(
                profile.location,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
          if(!CommonUtil.isTextEmpty(profile.blog))
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
              color: Theme.of(context).primaryColor,
              child: SimpleChip(
                showSplash: false,
                avatar: Icon(
                  Icons.link_outlined,
                  size: 20,
                  color: Colors.grey
                ),
                label: Text(
                  profile.blog,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold
                  ),
                ),
                onTap: () => launch(profile.blog),
              ),
            ),
          if(!CommonUtil.isTextEmpty(profile.email))
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
              color: Theme.of(context).primaryColor,
              child: SimpleChip(
                showSplash: false,
                avatar: Icon(
                  Icons.email_outlined,
                  size: 20,
                  color: Colors.grey
                ),
                label: Text(
                  profile.email,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold
                  ),
                ),
                onTap: () => launch('mailto:${profile.email}'),
              ),
            ),
          if(widget.pageType != PAGE_TYPE_PROFILE_ORG)
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
              color: Theme.of(context).primaryColor,
              child: SimpleChip(
                avatar: Icon(
                  Icons.person_outline_outlined,
                  size: 20,
                  color: Colors.grey
                ),
                label: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "${CommonUtil.numToThousand(profile.followers)} ",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.bold
                        ),
                        recognizer: TapGestureRecognizer()..onTap = (){
                          OwnersRoute.push(
                            context,
                            name: profile.login,
                            routeType: ROUTE_TYPE_OWNERS_FOLLOWER
                          );
                        }
                      ),
                      TextSpan(
                          text: AppLocalizations.of(context).followers
                      ),
                      TextSpan(
                        text: " · ",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.w900
                        ),
                      ),
                      TextSpan(
                        text: "${CommonUtil.numToThousand(profile.following)} ",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.bold
                        ),
                        recognizer: TapGestureRecognizer()..onTap = (){
                          OwnersRoute.push(
                            context,
                            name: profile.login,
                            routeType: ROUTE_TYPE_OWNERS_FOLLOWING
                          );
                        }
                      ),
                      TextSpan(
                          text: AppLocalizations.of(context).following
                      )
                    ]
                  ),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
          if(widget.pageType == PAGE_TYPE_PROFILE_USER && isFollowing != null)
            Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              width: MediaQuery.of(context).size.width - 50,
              color: Theme.of(context).primaryColor,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: BlocBuilder<FollowCubit, FollowState>(
                    bloc: context.read<ProfileBloc>().followCubit,
                    builder: (context, state){
                      if(state is FollowingUserState){
                        return SizedBox(
                            height: 20,
                            width: 20,
                            child: LoadingWidget(isScroll: false)
                        );
                      }
                      if(state is FollowUserResultState){
                        isFollowing = state.isFollowing;
                      }
                      return SimpleChip(
                        avatar: Icon(
                          isFollowing ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
                          color: isFollowing ? Colors.amber : Theme.of(context).accentColor,
                          size: 20,
                        ),
                        label: Text(
                          isFollowing ? AppLocalizations.of(context).watching.toUpperCase() : AppLocalizations.of(context).watch.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: isFollowing ? Theme.of(context).textTheme.bodyText1.color : Theme.of(context).accentColor
                          ),
                        ),
                        gap: 6,
                      );
                    }
                  ),
                  onPressed: () => context.read<ProfileBloc>().add(FollowUserEvent(!isFollowing))
              ),
            ),
          Container(
            padding: EdgeInsets.only(top: 15),
            color: Theme.of(context).primaryColor,
            child: CustomDivider(bold: true),
          )
        ])
      ),
      SliverList(
        delegate: SliverChildListDelegate([
          Padding(padding: EdgeInsets.only(top: 15)),
          if(!CommonUtil.isTextEmpty(profile.reposUrl))
            TightListTile(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              backgroundColor: Theme.of(context).primaryColor,
              leading: Icon(
                Icons.receipt,
                color: Colors.purple,
              ),
              title: Text(AppLocalizations.of(context).repos),
              onTap: () => ReposRoute.push(
                context,
                name: profile.login,
                routeType: widget.pageType == PAGE_TYPE_PROFILE_USER ? ROUTE_TYPE_REPOS_USER : ROUTE_TYPE_REPOS_ORG
              )
            ),
          if(!CommonUtil.isTextEmpty(profile.organizationsUrl))
            TightListTile(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              backgroundColor: Theme.of(context).primaryColor,
              leading: Icon(
                Icons.people,
                color: Colors.orange,
              ),
              title: Text(AppLocalizations.of(context).orgs),
              onTap: () => OwnersRoute.push(
                context,
                name: profile.login,
                routeType: ROUTE_TYPE_OWNERS_ORG
              ),
            ),
          if(!CommonUtil.isTextEmpty(profile.starredUrl))
            TightListTile(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              backgroundColor: Theme.of(context).primaryColor,
              leading: Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              title: Text(AppLocalizations.of(context).starred),
              onTap: () => ReposRoute.push(
                context,
                name: profile.login,
                routeType: ROUTE_TYPE_REPOS_STARRED
              )
            ),
          if(!CommonUtil.isTextEmpty(profile.starredUrl))
            TightListTile(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              backgroundColor: Theme.of(context).primaryColor,
              leading: Icon(
                Icons.remove_red_eye,
                color: Colors.amber,
              ),
              title: Text(AppLocalizations.of(context).watching),
              onTap: () => ReposRoute.push(
                context,
                name: profile.login,
                routeType: ROUTE_TYPE_REPOS_WATCHING
              )
            ),
          if(!CommonUtil.isTextEmpty(profile.membersUrl))
            TightListTile(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              backgroundColor: Theme.of(context).primaryColor,
              leading: Icon(
                Icons.people,
                color: Colors.indigo,
              ),
              title: Text(AppLocalizations.of(context).members),
              onTap: () => OwnersRoute.push(
                context,
                name: profile.login,
                routeType: ROUTE_TYPE_OWNERS_MEMBER
              ),
          ),
          Container(
            padding: EdgeInsets.only(top: 1),
            color: Theme.of(context).primaryColor,
            child: CustomDivider(bold: true),
          )
        ])
      ),
    ];
  }

  List<Widget> _buildSliverEvents(BuildContext context, List<Event> events, bool hasMore){
    if(CommonUtil.isListEmpty(events)){
      return [];
    }
    return [
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: 15),
          padding: EdgeInsets.all(15),
          color: Theme.of(context).primaryColor,
          alignment: Alignment.centerLeft,
          child: Text(
            AppLocalizations.of(context).myActivity,
            style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w600),
          ),
        )
      ),
      buildSliverListWithFooter(
        context,
        itemCount: events.length,
        itemBuilder: (context, index){
          Event event = events[index];
          return CommonEventsItem(
            action: CommonUtil.getActionByEvent(context, event, false),
            date: DateUtil.parseTime(context, event.createdAt),
            onTap: () => RepoRoute.push(context, repoUrl: event.repo.url),
          );
        },
        hasMore: hasMore,
        onLoadMore: () => context.read<ProfileBloc>().getMoreEvents()
      ),
    ];
  }

  @override
  bool get wantKeepAlive => true;

}