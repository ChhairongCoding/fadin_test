import 'package:fardinexpress/features/app/extend_app_logistic/feature/transport_methods/model/transport_method_model.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class TransportMethodState extends Equatable {
  TransportMethodState([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class InitializingTransportMethod extends TransportMethodState {}

class FetchingTransportMethod extends TransportMethodState {}

class FetchedTransportMethod extends TransportMethodState {
  final List<TransportMothodModel> result;
  FetchedTransportMethod({required this.result});
}

class ErrorFetchingTransportMethod extends TransportMethodState {
  final String error;
  ErrorFetchingTransportMethod({required this.error});
}
