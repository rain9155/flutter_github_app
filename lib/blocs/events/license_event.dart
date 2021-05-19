part of '../license_bloc.dart';

@immutable
abstract class LicenseEvent {
  const LicenseEvent();
}

class GetLicenseEvent extends LicenseEvent{

  const GetLicenseEvent(this.key);

  final String? key;
}

class GotLicenseEvent extends LicenseEvent{

  const GotLicenseEvent({this.errorCode});

  final int? errorCode;
}
