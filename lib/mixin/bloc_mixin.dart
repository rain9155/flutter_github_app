import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


/// 把cancelToken混入Bloc中
mixin BlocMixin<E, S> on Bloc<E, S>{

  CancelToken cancelToken = CancelToken();

  bool hasMore(int lastPage, int curPage){
    return lastPage != null && curPage < lastPage;
  }

  @override
  Future<void> close() {
    cancelToken?.cancel();
    return super.close();
  }
}
