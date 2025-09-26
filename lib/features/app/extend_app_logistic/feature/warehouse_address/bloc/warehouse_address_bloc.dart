import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/warehouse_address/bloc/warehouse_address_event.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/warehouse_address/models/warehouse_address.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/warehouse_address/repositories/warehouse_address_repository.dart';

import 'warehouse_address_state.dart';

class WarehouseAddressBloc
    extends Bloc<WarehouseAddressEvent, WarehouseAddressState> {
  @override
  WarehouseAddressBloc() : super(FetchingWarehouseAddresses());
  final WarehouseAddressRepository _warehouseAddressRepository =
      WarehouseAddressRepository();
  @override
  Stream<WarehouseAddressState> mapEventToState(
      WarehouseAddressEvent event) async* {
    if (event is FetchWarehouseAddresses) {
      yield FetchingWarehouseAddresses();
      try {
        final List<WarehouseAddress> addressList =
            await _warehouseAddressRepository.getwarehouseaddresses();
        yield FetchedWarehouseAddresses(addressList: addressList);
      } catch (e) {
        yield ErrorFetchingWarehouseAddresses(error: e.toString());
      }
    }
  }
}
