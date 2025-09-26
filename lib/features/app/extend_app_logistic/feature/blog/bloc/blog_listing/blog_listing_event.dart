import 'package:equatable/equatable.dart';

abstract class InfoListingEvent extends Equatable {
  @override
  List<Object> get props => [];
  InfoListingEvent();
}

class InitializeInfoList extends InfoListingEvent {
  final arg;
  InitializeInfoList({this.arg});
}

class FetchInfoList extends InfoListingEvent {
  final arg;
  FetchInfoList({required this.arg});
}
