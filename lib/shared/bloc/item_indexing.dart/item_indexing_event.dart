import 'package:equatable/equatable.dart';

abstract class ItemIndexingEvent extends Equatable {
  ItemIndexingEvent([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class Taped extends ItemIndexingEvent {
  Taped({required this.index}) : super([index]);
  final int index;
}
