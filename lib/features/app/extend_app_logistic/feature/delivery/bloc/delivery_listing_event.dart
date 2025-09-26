import 'package:equatable/equatable.dart';

abstract class DeliveryListingEvent extends Equatable {
  DeliveryListingEvent([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class FetchDeliveryList extends DeliveryListingEvent {
  final String? additionalArg;
  FetchDeliveryList({required this.additionalArg});
}
