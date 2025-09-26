import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/models/estimation_result.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/models/target_country_list.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/transport_methods/model/transport_method_model.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/repositories/price_estimation_repository.dart';
import 'price_estimation_event.dart';
import 'price_estimation_state.dart';

class PriceEstimationBloc
    extends Bloc<PriceEstimationEvent, PriceEstimationState> {
  PriceEstimationRepository priceEstimationRepository =
      PriceEstimationRepository();
  TargetCountryModel? targetCountryModel;
  @override
  PriceEstimationBloc() : super(InitializingPriceEstimation());
  // List<TransportMothodModel> transportMethods = [];

  @override
  Stream<PriceEstimationState> mapEventToState(
      PriceEstimationEvent event) async* {
    if (event is FetchPrice) {
      yield FetchingPrice();
      try {
        final EstimationResult result = await priceEstimationRepository
            .getPrice(estimation: event.estimation);
        yield FetchedPrice(result: result);
      } catch (e) {
        yield ErrorFetchingPrice(error: e.toString());
      }
    }
    if (event is FetchTargetCountryList) {
      yield FetchingTargetCountry();
      try {
        final targetCountryList =
            await priceEstimationRepository.getTargetCountryList();
        yield FetchedTargetCountry(result: targetCountryList);
      } catch (e) {
        yield ErrorFetchingTargetCountry(error: e.toString());
      }
    }

    if (event is FetchTargetCountryById) {
      yield FetchingTargetCountryById();
      try {
        targetCountryModel = await priceEstimationRepository
            .getTargetCountryById(countryId: event.id);
        yield FetchedTargetCountryById(targetCountryModel: targetCountryModel!);
      } catch (e) {
        yield ErrorFetchingTargetCountryById(error: e.toString());
      }
    }
    // if (event is FetchTransportMethodList) {
    //   yield FetchingTransportMethod();
    //   try {
    //     transportMethods.clear();
    //     final transportMethodList =
    //         await priceEstimationRepository.getTransportMethodList(event.id);
    //     if (transportMethodList.length != 0) {
    //       transportMethods.addAll(transportMethodList);
    //     }
    //     yield FetchedTransportMethod(result: transportMethodList);
    //   } catch (e) {
    //     yield ErrorFetchingTransportMethod(error: e.toString());
    //   }
    // }
  }
}
