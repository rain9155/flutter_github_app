part of '../home_bloc.dart';

@immutable
abstract class HomeEvent {
  const HomeEvent();
}

class GetReceivedEventsEvent extends HomeEvent{}

class GotReceivedEventsEvent extends HomeEvent{

  const GotReceivedEventsEvent({
    this.errorCode
  });

  final int? errorCode;
}
