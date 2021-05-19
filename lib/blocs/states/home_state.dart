part of '../home_bloc.dart';

@immutable
abstract class HomeState {
  const HomeState();
}

class HomeInitialState extends HomeState {}

class GettingReceivedEventsState extends HomeState {}

class GetReceivedEventsSuccessState extends HomeState {

  const GetReceivedEventsSuccessState(
    this.events,
    this.hasMore,
  );

  final List<Event>? events;

  final bool hasMore;
}

class GetReceivedEventsFailureState extends GetReceivedEventsSuccessState{

  const GetReceivedEventsFailureState(
    List<Event>? events,
    bool hasMore,
    this.errorCode,
  ): super(events, hasMore);

  final int? errorCode;
}


