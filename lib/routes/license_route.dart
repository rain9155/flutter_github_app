
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/license.dart';
import 'package:flutter_github_app/blocs/license_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/toast_util.dart';
import 'package:flutter_github_app/widgets/common_action.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/loading_widget.dart';
import 'package:flutter_github_app/widgets/try_again_widget.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class LicenseRoute extends StatelessWidget{

  static final name = 'LicenseRoute';

  static route(){
    return BlocProvider(
      create: (_) => LicenseBloc(),
      child: LicenseRoute._(),
    );
  }

  static Future push(BuildContext context, {
    @required String key,
    @required String name,
  }){
    return Navigator.of(context).pushNamed(LicenseRoute.name, arguments: {
      KEY_NAME: name,
      KEY_LICENSE_KEY: key
    });
  }

  LicenseRoute._();

  String _key;
  String _name;
  String _htmlUrl;

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context).settings.arguments as Map;
    _key = arguments[KEY_LICENSE_KEY];
    _name = arguments[KEY_NAME];
    return CommonScaffold(
      sliverHeaderBuilder: (context, _){
        return _buildSliverAppBar(context);
      },
      body: _buildBody(),
      onRefresh: () => context.read<LicenseBloc>().refreshLicense(),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return CommonSliverAppBar(
      title: CommonTitle(_name),
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
          },
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
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BlocBuilder<LicenseBloc, LicenseState>(
      builder: (context, state){
        if(state is GettingLicenseState){
          return _buildBodyWithLoading(context);
        }
        if(state is GetLicenseFailureState){
          return _buildBodyWithFailure(context, state);
        }
        if(state is GetLicenseSuccessState){
          return _buildBodyWithSuccess(context, state);
        }
        context.read<LicenseBloc>().add(GetLicenseEvent(_key));
        return Container();
      },
    );
  }

  Widget _buildBodyWithLoading(BuildContext context) {
    return LoadingWidget();
  }

  Widget _buildBodyWithFailure(BuildContext context, GetLicenseFailureState state) {
    if(state.license == null){
      return TryAgainWidget(
        code: state.errorCode,
        onTryPressed: () => context.read<LicenseBloc>().add(GetLicenseEvent(_key)),
      );
    }
    return _buildSliverLicense(context, state.license);
  }

  Widget _buildBodyWithSuccess(BuildContext context, GetLicenseSuccessState state) {
    return _buildSliverLicense(context, state.license);
  }

  Widget _buildSliverLicense(BuildContext context, License license){
    _htmlUrl = license.htmlUrl;
    return Container(
      color: Theme.of(context).primaryColor,
      child: Markdown(data: license.body)
    );
  }

}