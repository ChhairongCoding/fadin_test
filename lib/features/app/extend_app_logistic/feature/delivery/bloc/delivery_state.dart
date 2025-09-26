import 'package:equatable/equatable.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/models/delivery.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/constants/app_constant.dart';

abstract class DeliveryState extends Equatable {
  DeliveryState([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class InitializingDelivery extends DeliveryState {}

class RequestedDelivery extends DeliveryState {
  final Delivery delivery;
  RequestedDelivery({required this.delivery});
}

class RequestingDelivery extends DeliveryState {}

class ErrorRequestingDelivery extends DeliveryState with ErrorState {
  final dynamic error;
  ErrorRequestingDelivery({required this.error});
}
