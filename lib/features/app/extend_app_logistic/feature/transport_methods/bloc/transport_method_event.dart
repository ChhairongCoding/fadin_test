import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class TransportMethodEvent extends Equatable {
  TransportMethodEvent([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class FetchTransportMethodList extends TransportMethodEvent {
  final String id;
  FetchTransportMethodList({required this.id});
}
