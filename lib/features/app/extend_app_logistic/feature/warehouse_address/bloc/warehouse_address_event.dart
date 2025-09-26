import 'package:equatable/equatable.dart';

abstract class WarehouseAddressEvent extends Equatable {
  WarehouseAddressEvent([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class FetchWarehouseAddresses extends WarehouseAddressEvent {}
