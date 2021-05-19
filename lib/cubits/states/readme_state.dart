part of '../readme_cubit.dart';

@immutable
abstract class ReadmeState {
  const ReadmeState();
}

class ReadmeInitialState extends ReadmeState {}

class UpdatingReadmeState extends ReadmeState {}

class UpdateReadmeResultState extends ReadmeState {

  const UpdateReadmeResultState({
    this.readme,
    this.errorCode
  });

  final String? readme;

  final int? errorCode;
}

