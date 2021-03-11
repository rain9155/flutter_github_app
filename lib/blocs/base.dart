
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBloc<E, S> extends Bloc<E, S>{

  BaseBloc(S initialState) : super(initialState);

  CancelToken cancelToken = CancelToken();

  @override
  Future<Function> close() {
    cancelToken?.cancel();
    return super.close();
  }
}
