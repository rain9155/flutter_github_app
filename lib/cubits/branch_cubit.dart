import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'states/branch_state.dart';

class BranchCubit extends Cubit<BranchState>{
  BranchCubit() : super(BranchInitialState());
}
