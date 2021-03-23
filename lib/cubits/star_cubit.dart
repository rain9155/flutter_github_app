import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'states/star_state.dart';

class StarCubit extends Cubit<StarState> {
  StarCubit() : super(StarInitialState());
}
