part of '../star_cubit.dart';

@immutable
abstract class StarState {
  const StarState();
}

class StarInitialState extends StarState {}

class StarringRepoState extends StarState{}

class StarRepoResultState extends StarState{

  const StarRepoResultState(this.isStarred);

  final bool? isStarred;

}
