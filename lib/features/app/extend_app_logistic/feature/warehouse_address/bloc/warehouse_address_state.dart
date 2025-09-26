import 'package:equatable/equatable.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/warehouse_address/models/warehouse_address.dart';

abstract class WarehouseAddressState extends Equatable {
  WarehouseAddressState([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class FetchedWarehouseAddresses extends WarehouseAddressState {
  final List<WarehouseAddress> addressList;
  FetchedWarehouseAddresses({required this.addressList});
}

class FetchingWarehouseAddresses extends WarehouseAddressState {}

class ErrorFetchingWarehouseAddresses extends WarehouseAddressState {
  final String error;
  ErrorFetchingWarehouseAddresses({required this.error});
}
