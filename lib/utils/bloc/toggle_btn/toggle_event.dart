import 'package:equatable/equatable.dart';

abstract class ToggleEvent extends Equatable {
  ToggleEvent([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class ClickedIndex extends ToggleEvent {
  ClickedIndex({required this.clicked}) : super([clicked]);
  final bool clicked;
}
