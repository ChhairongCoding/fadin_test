import 'package:equatable/equatable.dart';

abstract class NavbarIndexingEvent extends Equatable {
  const NavbarIndexingEvent([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class Taped extends NavbarIndexingEvent {
  Taped({required this.index}) : super([index]);
  final int index;
}
