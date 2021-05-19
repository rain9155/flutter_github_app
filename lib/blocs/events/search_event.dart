part of '../search_bloc.dart';

@immutable
abstract class SearchEvent {
  const SearchEvent();
}

class GetHistoriesEvent extends SearchEvent{}

class GotHistoriesEvent extends SearchEvent{}

class TextChangedEvent extends SearchEvent{

  const TextChangedEvent(this.hasText);

  final bool hasText;
}

class DeleteHistoryEvent extends SearchEvent{

  const DeleteHistoryEvent(this.history);

  final String history;
}

class DeleteHistoriesEvent extends SearchEvent{}

class SaveHistoryEvent extends SearchEvent{

  const SaveHistoryEvent(this.history);

  final String? history;
}

class StartSearchEvent extends SearchEvent{

  const StartSearchEvent(this.key);

  final String? key;
}

class GotSearchEvent extends SearchEvent{

  const GotSearchEvent({this.errorCode});

  final int? errorCode;
}