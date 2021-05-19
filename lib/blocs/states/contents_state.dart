part of '../contents_bloc.dart';

@immutable
abstract class ContentsState {
  const ContentsState();
}

class ContentsInitialState extends ContentsState {}

class GettingContentsState extends ContentsState{}

class GetContentsSuccessState extends ContentsState{

  const GetContentsSuccessState(this.contents);

  final List<Content>? contents;
}

class GetContentsFailureState extends GetContentsSuccessState{

  const GetContentsFailureState(
    List<Content>? contents,
    this.errorCode
  ): super(contents);

  final int? errorCode;
}