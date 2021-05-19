part of '../owners_bloc.dart';

@immutable
abstract class OwnersState {
  const OwnersState();
}

class OwnersInitialState extends OwnersState {}

class GettingOwnersState extends OwnersState {}

class GetOwnersSuccessState extends OwnersState {

  const GetOwnersSuccessState(this.owners, this.hasMore);

  final List<Owner>? owners;

  final bool hasMore;
}

class GetOwnersFailureState extends GetOwnersSuccessState{

  const GetOwnersFailureState(
    List<Owner>? owners,
    bool hasMore,
    this.errorCode
  ): super(owners, hasMore);

  final int? errorCode;
}
