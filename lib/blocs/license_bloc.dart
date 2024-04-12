import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_github_app/beans/license.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/mixin/bloc_mixin.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:meta/meta.dart';

part 'events/license_event.dart';
part 'states/license_state.dart';

class LicenseBloc extends Bloc<LicenseEvent, LicenseState> with BlocMixin{

  LicenseBloc() : super(LicenseInitialState()) {
    on<LicenseEvent>(mapEventToState, transformer: sequential());
  }

  String? _key;
  bool _isRefreshing = false;
  License? _license;

  FutureOr<void> mapEventToState(LicenseEvent event, Emitter<LicenseState> emit) async {
    if(event is GetLicenseEvent){
      emit(GettingLicenseState());
      _key = event.key;
      await refreshLicense(isRefresh: false);
    }

    if(event is GotLicenseEvent){
      if(event.errorCode == null){
        emit(GetLicenseSuccessState(_license));
      }else{
        emit(GetLicenseFailureState(_license, event.errorCode));
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
