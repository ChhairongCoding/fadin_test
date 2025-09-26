import 'package:equatable/equatable.dart';

abstract class ToggleState extends Equatable {
  const ToggleState();
  @override
  List<Object> get props => [];
}

class InitialClick extends ToggleState {}

class ClickTrue extends ToggleState {}

class ClickFalse extends ToggleState {}
