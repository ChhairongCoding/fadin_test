import 'package:equatable/equatable.dart';

abstract class InfoCategoryEvent extends Equatable {
  InfoCategoryEvent([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class FetchInfoCategoryStarted extends InfoCategoryEvent {}
