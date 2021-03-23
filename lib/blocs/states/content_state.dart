part of '../content_bloc.dart';

@immutable
abstract class ContentState {
  const ContentState();
}

class ContentInitialState extends ContentState {}

class GettingContentState extends ContentState {}

class GetContentSuccessState extends ContentState {

  const GetContentSuccessState(this.content);

  final String content;
}

class GetContentFailureState extends GetContentSuccessState {

  const GetContentFailureState(
    String content,
    this.errorCode
  ): super(content);

  final int errorCode;
}


