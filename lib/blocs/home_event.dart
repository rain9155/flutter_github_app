part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {
  const HomeEvent();
}

class GetReceivedEventsEvent extends HomeEvent{}

class RefreshedReceivedEventsEvent extends HomeEvent{

  const RefreshedReceivedEventsEvent(this.error);

  final String error;
}

class GetMoreReceivedEventsEvent extends HomeEvent{}
