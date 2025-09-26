import 'package:equatable/equatable.dart';

abstract class DeliveryEvent extends Equatable {
  DeliveryEvent([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class RequestDelivery extends DeliveryEvent {
  final String deliveryId;
  final String address;
  RequestDelivery({required this.deliveryId, required this.address});
}
