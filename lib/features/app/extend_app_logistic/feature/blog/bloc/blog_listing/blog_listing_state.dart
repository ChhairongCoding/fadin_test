import 'package:equatable/equatable.dart';

abstract class InfoListingState extends Equatable {
  const InfoListingState();

  @override
  List<Object> get props => [];
}

class InitializingInfoList extends InfoListingState {}

class InitializedInfoList extends InfoListingState {}

class FetchingInfoList extends InfoListingState {}

class FetchedInfoList extends InfoListingState {}

class EndOfInfoList extends InfoListingState {}

class ErrorFetchingInfoList extends InfoListingState {
  final String error;
  ErrorFetchingInfoList({required this.error});
  @override
  String toString() => 'LoadingFavourite';
}

class ErrorInitializingInfoList extends InfoListingState {
  final String error;
  ErrorInitializingInfoList({required this.error});
  @override
  String toString() => 'LoadingFavourite';
}
