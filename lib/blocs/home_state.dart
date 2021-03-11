part of 'home_bloc.dart';

@immutable
abstract class HomeState {
  const HomeState();
}

class HomeInitialState extends HomeState {}

class GettingReceivedEventsState extends HomeState {}

class GetReceivedEventsSuccessState extends HomeState {

  const GetReceivedEventsSuccessState(
      this.events,
      this.increasedCount,
      );

  final List<Event> events;

  final int increasedCount;
}

class GetReceivedEventsFailureState extends HomeState {

  const GetReceivedEventsFailureState(
      this.isGetMore,
      this.events,
      this.error
    );

  final bool isGetMore;

  final List<Event> events;

  final String error;
}


