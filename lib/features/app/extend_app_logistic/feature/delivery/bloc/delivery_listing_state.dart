import 'package:equatable/equatable.dart';

abstract class DeliveryListingState extends Equatable {
  DeliveryListingState([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class FetchedDeliveryList extends DeliveryListingState {}

class FetchingDeliveryList extends DeliveryListingState {}

class ErrorFetchingDeliveryList extends DeliveryListingState {
  final dynamic error;
  ErrorFetchingDeliveryList({required this.error});
}
