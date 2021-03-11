import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/event.dart';
import 'package:flutter_github_app/blocs/home_bloc.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/routes/repo_route.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/date_util.dart';
import 'package:flutter_github_app/utils/toast_util.dart';
import 'package:flutter_github_app/widgets/custom_divider.dart';
import 'package:flutter_github_app/widgets/pull_refersh_widget.dart';
import 'package:flutter_github_app/widgets/rounded_image.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';

class HomePage extends StatefulWidget{

  static page(){
    return BlocProvider(
      create: (context) => HomeBloc(context),
      child: HomePage(),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetReceivedEventsEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  _buildBody();
  }

  Widget _buildBody() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state){
        if(state is GettingReceivedEventsState){
          return _buildBodyWithSlivers(context, _buildLoadingSlivers(context));
        }
        if(state is GetReceivedEventsFailureState){
          return _buildBodyWithSlivers(context, _buildEventsSliversWithFailure(context, state));
        }
        if(state is GetReceivedEventsSuccessState){
          return _buildBodyWithSlivers(context, _buildEventsSliversWithSuccess(context, state));
        }
        return _buildBodyWithSlivers(context, []);
      },
    );
  }

  Widget _buildBodyWithSlivers(BuildContext context, [List<Widget> slivers]){
    return PullRefreshWidget(
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: _buildTitle(),
            actions: [
              _buildSearchAction(),
            ],
            elevation: 2,
            pinned: true,
          ),
          SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 20),
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    AppLocalizations.of(context).myWork,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                TightListTile(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  leading: Icon(
                      Icons.error,
                      color: Colors.green
                  ),
                  title: Text(AppLocalizations.of(context).issues),
                  backgroundColor: Theme.of(context).primaryColor,
                  onTap: (){},
                ),
                TightListTile(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  leading: Icon(
                    Icons.transform,
                    color: Colors.blue,
                  ),
                  title: Text(AppLocalizations.of(context).pullRequests),
                  backgroundColor: Theme.of(context).primaryColor,
                  onTap: (){},
                ),
                TightListTile(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  leading: Icon(
                    Icons.receipt,
                    color: Colors.purple,
                  ),
                  title: Text(AppLocalizations.of(context).repos),
                  backgroundColor: Theme.of(context).primaryColor,
                  onTap: (){
                    Navigator.of(context).pushNamed(RepoRoute.name);
                  },
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  color: Theme.of(context).primaryColor,
                  child: CustomDivider(),
                )
              ])
          ),
          ...?slivers,
        ],
      ),
      onRefresh: () => context.read<HomeBloc>().refreshReceivedEvents(),
    );
  }

  Widget _buildTitle() {
    return Builder(
        builder: (context){
          return Text(
            AppLocalizations.of(context).home,
            style: Theme.of(context).textTheme.headline6.copyWith(
                fontWeight: FontWeight.bold
            ),
          );
        }
    );
  }

  Widget _buildSearchAction() {
    return Builder(
      builder: (context){
        return IconButton(
          tooltip: AppLocalizations.of(context).search,
          icon: Icon(
            Icons.search_outlined,
            color: Theme.of(context).accentColor,
          ),
          onPressed: (){},
        );
      },
    );
  }

  List<Widget> _buildLoadingSlivers(BuildContext context){
    return [
      SliverFillRemaining(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      )
    ];
  }

  List<Widget> _buildEventsSliversWithFailure(BuildContext context, GetReceivedEventsFailureState state){
    if(!state.isGetMore){
      if(CommonUtil.isListEmpty(state.events)){
        return _buildErrorSlivers(context, state.error);
      }else{
        //ToastUtil.showToast(state.error);
        return _buildEventsSlivers(context, state.events, state.events.length, '');
      }
    }else{
      return _buildEventsSlivers(context, state.events, 0, state.error);
    }
  }

  List<Widget> _buildEventsSliversWithSuccess(BuildContext context, GetReceivedEventsSuccessState state){
    return _buildEventsSlivers(context, state.events, state.increasedCount, '');
  }

  List<Widget> _buildErrorSlivers(BuildContext context, String error){
    return [
      SliverFillRemaining(
        child: TryAgainWidget(
          hint: error,
          onTryPressed: (){
            context.read<HomeBloc>().add(GetReceivedEventsEvent());
          },
        ),
      )
    ];
  }

  List<Widget> _buildEventsSlivers(BuildContext context, List<Event> events, int increasedCount, String error){
    if(CommonUtil.isListEmpty(events)){
      return [];
    }
    return [
      SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
          alignment: Alignment.centerLeft,
          color: Theme.of(context).primaryColor,
          child: Text(
            AppLocalizations.of(context).myEvent,
            style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w600),
          ),
        )
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index){
          if(index == events.length){
            if(increasedCount > 0){
              context.read<HomeBloc>().add(GetMoreReceivedEventsEvent());
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
            backgroundColor: Theme.of(context).primaryColor,
            leading: RoundedImage.network(
              event.actor.avatarUrl,
              width: 35,
              height: 35,
              radius: 5.0,
            ),
            title: Text(
              CommonUtil.getActionByEvent(context, event),
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

