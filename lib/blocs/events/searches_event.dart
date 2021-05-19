part of '../searches_bloc.dart';

@immutable
abstract class SearchesEvent {
  const SearchesEvent();
}

class GetSearchesEvent extends SearchesEvent{

  const GetSearchesEvent(this.key, this.routeType);

  final String? key;

  final int? routeType;
}

class GotSearchesEvent extends SearchesEvent{

  const GotSearchesEvent({this.errorCode});

  final int? errorCode;
}
