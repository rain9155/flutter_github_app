import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_github_app/beans/license.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/mixin/bloc_mixin.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:meta/meta.dart';

part 'events/license_event.dart';
part 'states/license_state.dart';

class LicenseBloc extends Bloc<LicenseEvent, LicenseState> with BlocMixin{

  LicenseBloc() : super(LicenseInitialState());

  String _key;
  bool _isRefreshing = false;
  License _license;

  @override
  Stream<LicenseState> mapEventToState(LicenseEvent event) async* {
    if(event is GetLicenseEvent){
      yield GettingLicenseState();
      _key = event.key;
      await refreshLicense(isRefresh: false);
    }

    if(event is GotLicenseEvent){
      if(event.errorCode == null){
        yield GetLicenseSuccessState(_license);
      }else{
        yield GetLicenseFailureState(_license, event.errorCode);
      }
    }
  }

  Future<void> refreshLicense({bool isRefresh = true}) async{
    if(_isRefreshing){
      return;
    }
    _isRefreshing = true;
    await runBlockCaught(() async{
      _license = await Api.getInstance().getLicense(
        _key,
        noCache: isRefresh,
        cancelToken: cancelToken
      );
      add(GotLicenseEvent());
    }, onError: (code, msg){
      add(GotLicenseEvent(errorCode: code));
    });
    _isRefreshing = false;
  }
}
