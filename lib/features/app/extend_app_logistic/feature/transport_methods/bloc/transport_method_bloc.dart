import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/repositories/price_estimation_repository.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/transport_methods/bloc/transport_method_event.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/transport_methods/bloc/transport_method_state.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/transport_methods/model/transport_method_model.dart';

class TransportMethodBloc
    extends Bloc<TransportMethodEvent, TransportMethodState> {
  PriceEstimationRepository priceEstimationRepository =
      PriceEstimationRepository();
  @override
  TransportMethodBloc() : super(InitializingTransportMethod());
  List<TransportMothodModel> transportMethods = [];

  @override
  Stream<TransportMethodState> mapEventToState(
      TransportMethodEvent event) async* {
    if (event is FetchTransportMethodList) {
      yield FetchingTransportMethod();
      try {
        transportMethods.clear();
        final transportMethodList =
            await priceEstimationRepository.getTransportMethodList(event.id);
        if (transportMethodList.length != 0) {
          transportMethods.addAll(transportMethodList);
        }
        yield FetchedTransportMethod(result: transportMethodList);
      } catch (e) {
        yield ErrorFetchingTransportMethod(error: e.toString());
      }
    }
  }
}
