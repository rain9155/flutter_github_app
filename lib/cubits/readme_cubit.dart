import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'states/readme_state.dart';

class ReadmeCubit extends Cubit<ReadmeState> {
  ReadmeCubit() : super(ReadmeInitialState());
}
