part of '../license_bloc.dart';

@immutable
abstract class LicenseState {
  const LicenseState();
}

class LicenseInitialState extends LicenseState {}

class GettingLicenseState extends LicenseState{}

class GetLicenseSuccessState extends LicenseState{

  const GetLicenseSuccessState(this.license);

  final License license;
}

class GetLicenseFailureState extends GetLicenseSuccessState{

  const GetLicenseFailureState(
    License license,
    this.errorCode
  ): super(license);

  final int errorCode;
}