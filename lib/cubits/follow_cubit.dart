import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'states/follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  FollowCubit() : super(FollowInitialState());
}
