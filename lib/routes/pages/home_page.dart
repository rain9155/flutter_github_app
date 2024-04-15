import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/event.dart';
import 'package:flutter_github_app/blocs/home_bloc.dart';
import 'package:flutter_github_app/cubits/user_cubit.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/routes/all_route.dart';
import 'package:flutter_github_app/mixin/load_more_sliverlist_mixin.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/date_util.dart';
import 'package:flutter_github_app/widgets/common_action.dart';
import 'package:flutter_github_app/widgets/common_events_item.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/custom_divider.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/loading_widget.dart';
import 'package:flutter_github_app/widgets/tight_list_tile.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';

class HomePage extends StatefulWidget{

  static page(){
    return BlocProvider(
      create: (context) => HomeBloc(BlocProvider.of<UserCubit>(context)),
      child: HomePage._(),
    );
  }

  HomePage._();

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin, LoadMoreSliverListMixin{

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetReceivedEventsEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CommonScaffold(
      includeScaffold: false,
      sliverHeadersBuilder: (context, _){
        return [
          _buildSliverAppBar(context),
          _buildSliverHeader(context),
        ];
      },
      body: _buildBody(),
      onRefresh: () => context.read<HomeBloc>().refreshReceivedEvents(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state){
        if(state is GettingReceivedEventsState){
          return _buildBodyWithSlivers(context, _buildSliverLoading(context));
        }
        if(state is GetReceivedEventsFailureState){
          return _buildBodyWithSlivers(context, _buildSliverEventsWithFailure(context, state));
        }
        if(state is GetReceivedEventsSuccessState){
          return _buildBodyWithSlivers(context, _buildSliverEventsWithSuccess(context, state));
        }
        return _buildBodyWithSlivers(context, []);
      },
    );
  }

  Widget _buildBodyWithSlivers(BuildContext context, [List<Widget>? slivers]){
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(top: 10),
            color: Theme.of(context).primaryColor,
            child: CustomDivider(bold: (CommonUtil.isListEmpty(slivers) || slivers!.length == 1)),
          ),
        ),
        ...?slivers,
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context){
    return CommonSliverAppBar(
      showLeading: false,
      title: CommonTitle(AppLocalizations.of(context).home),
      actions: [
        CommonAction(
          icon: Icons.search_outlined,
          tooltip: AppLocalizations.of(context).search,
          onPressed: () => SearchRoute.push(context),
        )
      ]
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).primaryColor,
            child: Text(
              AppLocalizations.of(context).myWork,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
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
            onTap: () => IssuesRoute.push(context),
          ),
          TightListTile(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            backgroundColor: Theme.of(context).primaryColor,
            leading: Icon(
              Icons.people,
              color: Colors.orange,
            ),
            title: Text(AppLocalizations.of(context).orgs),
            onTap: () => OwnersRoute.push(context),
          ),
          TightListTile(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            leading: Icon(
              Icons.receipt,
              color: Colors.purple,
            ),
            title: Text(AppLocalizations.of(context).repos),
            backgroundColor: Theme.of(context).primaryColor,
            onTap: () => ReposRoute.push(context),
          ),
        ])
    );
  }

  List<Widget> _buildSliverLoading(BuildContext context){
    return [
      SliverFillRemaining(
        child: LoadingWidget(),
      )
    ];
  }

  List<Widget> _buildSliverEventsWithFailure(BuildContext context, GetReceivedEventsFailureState state){
    if(state.events == null){//第一次加载后失败
      return _buildSliverError(context, state.errorCode);
    }
    //刷新失败
    //ToastUtil.showToast(state.error);
    return _buildSliverEvents(context, state.events, state.hasMore);
  }

  List<Widget> _buildSliverEventsWithSuccess(BuildContext context, GetReceivedEventsSuccessState state){
    return _buildSliverEvents(context, state.events, state.hasMore);
  }

  List<Widget> _buildSliverError(BuildContext context, int? code){
    return [
      SliverFillRemaining(
        child: TryAgainWidget(
          code: code,
          onTryPressed: (){
            context.read<HomeBloc>().add(GetReceivedEventsEvent());
          },
        ),
      )
    ];
  }

  List<Widget> _buildSliverEvents(BuildContext context, List<Event>? events, bool hasMore){
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
            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
          ),
        )
      ),
      buildSliverListWithFooter(
        context,
        itemCount: events!.length,
        itemBuilder: (context, index){
          Event event = events[index];
          return CommonEventsItem(
            actorAvatarUrl: event.actor!.avatarUrl,
            action: CommonUtil.getActionByEvent(context, event),
            date: DateUtil.parseTime(context, event.createdAt!),
            onTap: () => RepoRoute.push(context, repoUrl: event.repo!.url),
          );
        },
        hasMore: hasMore,
        onLoadMore: () => context.read<HomeBloc>().getMoreReceivedEvents()
      ),
    ];
  }

  @override
  bool get wantKeepAlive => true;
}

