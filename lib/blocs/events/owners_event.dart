part of '../owners_bloc.dart';

@immutable
abstract class OwnersEvent {
  const OwnersEvent();
}


class GetOwnersEvent extends OwnersEvent{

  const GetOwnersEvent(this.name, this.repoName, this.routeType);

  final String name;

  final String repoName;

  final int routeType;
}

class GotOwnersEvent extends OwnersEvent{

  const GotOwnersEvent({
    this.errorCode
  });

  final int errorCode;
}