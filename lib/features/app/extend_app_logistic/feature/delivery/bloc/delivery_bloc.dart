// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/models/delivery.dart';
// import 'delivery_event.dart';
// import 'delivery_state.dart';

// class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
//   List<Delivery> deliveryList = [];
//   final DeliveryRepository deliveryRepository = DeliveryRepository();
//   @override
//   DeliveryBloc() : super(InitializingDelivery());

//   @override
//   Stream<DeliveryState> mapEventToState(DeliveryEvent event) async* {
//     if (event is RequestDelivery) {
//       yield RequestingDelivery();
//       try {
//         Delivery delivery = await deliveryRepository.requestDelivery(
//             deliveryId: event.deliveryId, address: event.address);

//         yield RequestedDelivery(delivery: delivery);
//       } catch (e) {
//         yield ErrorRequestingDelivery(error: e);
//       }
//     }
//   }
// }
