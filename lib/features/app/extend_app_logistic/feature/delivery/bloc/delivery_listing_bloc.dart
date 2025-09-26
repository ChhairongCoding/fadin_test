import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/models/delivery.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/repositories/delivery_listing_repository.dart';
import 'delivery_listing_event.dart';
import 'delivery_listing_state.dart';

class DeliveryListingBloc
    extends Bloc<DeliveryListingEvent, DeliveryListingState> {
  List<Delivery> deliveryList = [];
  final DeliveryListingRepository deliveryListingRepository;
  int page = 1;
  @override
  DeliveryListingBloc({required this.deliveryListingRepository})
      : super(FetchingDeliveryList());

  @override
  Stream<DeliveryListingState> mapEventToState(
      DeliveryListingEvent event) async* {
    if (event is FetchDeliveryList) {
      yield FetchingDeliveryList();
      if (deliveryList.length != 0) deliveryList.clear();
      try {
        final tempDeliveryList =
            await deliveryListingRepository.getDeliveryList(
                page: page, rowPerPage: 10, additionalArg: event.additionalArg);
        deliveryList.addAll(tempDeliveryList);
        // page++;
        yield FetchedDeliveryList();
      } catch (e) {
        print(e.toString());
        yield ErrorFetchingDeliveryList(error: e);
      }
    }
  }
}
