
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/event.dart';
import 'package:flutter_github_app/beans/user.dart';
import 'package:flutter_github_app/blocs/profile_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/date_util.dart';
import 'package:flutter_github_app/utils/toast_util.dart';
import 'package:flutter_github_app/widgets/custom_divider.dart';
import 'package:flutter_github_app/widgets/custom_scroll_config.dart';
import 'package:flutter_github_app/widgets/pull_refersh_widget.dart';
import 'package:flutter_github_app/widgets/rounded_image.dart';
import 'package:flutter_github_app/widgets/simple_chip.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';

class ProfilePage extends StatefulWidget{

  static page(){
    return BlocProvider(
      create: (context) => ProfileBloc(context),
      child: ProfilePage(),
    );
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin{

  TapGestureRecognizer _followersTapGestureRecognizer;
  TapGestureRecognizer _followingTapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetUserEvent());
    _followersTapGestureRecognizer = TapGestureRecognizer()..onTap = _handleFollowersTap();
    _followingTapGestureRecognizer = TapGestureRecognizer()..onTap = _handleFollowingTap();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildBody();
  }

  Widget _buildBody() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state){
        if(state is GettingUserState){
          return _buildBodyWithLoading(context);
        }
        if(state is GetUserFailureState){
          return _buildBodyWithFailure(context, state);
        }
        if(state is GetUserSuccessState){
          return _buildBodyWithSuccess(context, state);
        }
        return Container();
      },
    );
  }

  Widget _buildBodyWithLoading(BuildContext context){
    return _buildProfileWidgetWithSlivers(context, _buildLoadingSlivers(context));
  }

  Widget _buildBodyWithFailure(BuildContext context, GetUserFailureState state){
    if(!state.isGetMore){
      if(state.user != null && state.events != null){
        //ToastUtil.showToast(state.error);
        return _buildProfileWidgetWithSlivers(context, [
          ...?_buildUserSlivers(context, state.user),
          ...?_buildEventsSlivers(context, state.events, state.events.length, '')
        ]);
      }else{
        return _buildProfileWidgetWithSlivers(context, _buildErrorSlivers(context, state.error));
      }
    }else{
      return _buildProfileWidgetWithSlivers(context, [
        ...?_buildUserSlivers(context, state.user),
        ...?_buildEventsSlivers(context, state.events, 0, state.error)
      ]);
    }
  }

  Widget _buildBodyWithSuccess(BuildContext context, GetUserSuccessState state){
    return _buildProfileWidgetWithSlivers(context, [
      ...?_buildUserSlivers(context, state.user),
      ...?_buildEventsSlivers(context, state.events, state.increasedCount, '')
    ]);
  }

  Widget _buildProfileWidgetWithSlivers(BuildContext context, List<Widget> slivers){
    return PullRefreshWidget(
        child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                title: _buildTitle(),
                actions: [
                  _buildShareAction(),
                  _buildSettingsAction()
                ],
                elevation: 2,
                pinned: true,
              ),
              ...?slivers
            ]
        ),
        onRefresh: () => context.read<ProfileBloc>().refreshUser()
    );
  }

  Widget _buildTitle() {
    return Builder(
      builder: (context){
        return Text(
          AppLocalizations.of(context).profile,
          style: Theme.of(context).textTheme.headline6.copyWith(
              fontWeight: FontWeight.bold
          ),
        );
      },
    );
  }

  Widget _buildShareAction() {
    return Builder(
      builder: (context){
        return IconButton(
            tooltip: AppLocalizations.of(context).share,
            icon: Icon(
              Icons.share_outlined,
              color: Theme.of(context).accentColor,
            ),
            onPressed: (){}
        );
      },
    );
  }

  Widget _buildSettingsAction() {
    return Builder(
      builder: (context){
        return IconButton(
            tooltip: AppLocalizations.of(context).settings,
            icon: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).accentColor,
            ),
            onPressed: (){}
        );
      },
    );
  }

  List<Widget> _buildLoadingSlivers(BuildContext context){
    return [
      SliverFillRemaining(
          child: Center(
              child: CircularProgressIndicator()
          )
      )
    ];
  }

  List<Widget> _buildErrorSlivers(BuildContext context, String error){
    return [
      SliverFillRemaining(
        child: TryAgainWidget(
          hint: error,
          onTryPressed: () => context.read<ProfileBloc>().add(GetUserEvent()),
        ),
      )
    ];
  }

  _handleFollowersTap(){

  }

  _handleFollowingTap(){

  }

  List<Widget> _buildUserSlivers(BuildContext context, User user){
    return [
      SliverList(
          delegate: SliverChildListDelegate([
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
              color: Theme.of(context).primaryColor,
              child: Row(
                children: [
                  RoundedImage.network(
                    user.avatarUrl,
                    width: 65,
                    height: 65,
                    radius: 8.0,
                    errorBuilder: (context, error, stack){
                      return Image.asset(PATH_BRAND_IMG);
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(!CommonUtil.isTextEmpty(user.name))
                          Text(
                            user.name,
                            style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        Text(
                          user.login,
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
            Builder(
              builder: (context){
                if(CommonUtil.isTextEmpty(user.bio)){
                  return Container();
                }
                return Container(
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    color: Theme.of(context).primaryColor,
                    child: Text(
                        user.bio,
                        style: Theme.of(context).textTheme.subtitle1
                    )
                );
              },
            ),
            Builder(
                builder: (context){
                  if(CommonUtil.isTextEmpty(user.location)){
                    return Container();
                  }
                  return Container(
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    color: Theme.of(context).primaryColor,
                    child: SimpleChip(
                      avatar: Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: Theme.of(context).disabledColor,
                      ),
                      label: Text(
                        user.location,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  );
                }
            ),
            Builder(
              builder: (context){
                if(CommonUtil.isTextEmpty(user.blog)){
                  return Container();
                }
                return Container(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  color: Theme.of(context).primaryColor,
                  child: SimpleChip(
                    showSplash: false,
                    avatar: Icon(
                      Icons.link_outlined,
                      size: 20,
                      color: Theme.of(context).disabledColor,
                    ),
                    label: Text(
                      user.blog,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: (){},
                  ),
                );
              },
            ),
            Builder(
              builder: (context){
                if(CommonUtil.isTextEmpty(user.email)){
                  return Container();
                }
                return Container(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  color: Theme.of(context).primaryColor,
                  child: SimpleChip(
                    showSplash: false,
                    avatar: Icon(
                      Icons.email_outlined,
                      size: 20,
                      color: Theme.of(context).disabledColor,
                    ),
                    label: Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: (){},
                  ),
                );
              },
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
              color: Theme.of(context).primaryColor,
              child: SimpleChip(
                avatar: Icon(
                  Icons.person_outline_outlined,
                  size: 20,
                  color: Theme.of(context).disabledColor,
                ),
                label: Text.rich(
                  TextSpan(
                      children: [
                        TextSpan(
                            text: "${user.followers} ",
                            style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontWeight: FontWeight.bold
                            ),
                            recognizer: _followersTapGestureRecognizer
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
                            text: "${user.following} ",
                            style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontWeight: FontWeight.bold
                            ),
                            recognizer: _followingTapGestureRecognizer
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
            Container(
              padding: EdgeInsets.only(top: 15),
              color: Theme.of(context).primaryColor,
              child: CustomDivider(),
            )
          ])
      ),
      SliverList(
          delegate: SliverChildListDelegate([
            Padding(padding: EdgeInsets.only(top: 15)),
            TightListTile(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              backgroundColor: Theme.of(context).primaryColor,
              leading: Icon(
                Icons.receipt,
                color: Colors.purple,
              ),
              title: Text(AppLocalizations.of(context).repos),
              onTap: (){},
            ),
            TightListTile(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              backgroundColor: Theme.of(context).primaryColor,
              leading: Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              title: Text(AppLocalizations.of(context).starred),
              onTap: (){},
            ),
            TightListTile(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              backgroundColor: Theme.of(context).primaryColor,
              leading: Icon(
                Icons.remove_red_eye,
                color: Colors.orange,
              ),
              title: Text(AppLocalizations.of(context).watching),
              onTap: (){},
            ),
            CustomDivider()
          ])
      ),
    ];
  }

  List<Widget> _buildEventsSlivers(BuildContext context, List<Event> events, int increasedCount, String error){
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
      SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index){
              if(index == events.length){
                if(increasedCount > 0){
                  context.read<ProfileBloc>().add(GetMoreUserEventsEvent());
                }
                return Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(!CommonUtil.isTextEmpty(error)
                      ? error : increasedCount > 0
                      ? AppLocalizations.of(context).loadingMore
                      : AppLocalizations.of(context).loadComplete
                  ),
                );
              }
              Event event = events[index];
              return TightListTile(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 80,
                titlePadding: EdgeInsets.only(right: 15),
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(
                  CommonUtil.getActionByEvent(context, event, false),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  DateUtil.parseTime(context, event.createdAt),
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.grey,
                  ),
                ),
                onTap: (){},
              );
            },
            childCount: events.length + 1
        )
      )
    ];
  }

  @override
  bool get wantKeepAlive => true;

}