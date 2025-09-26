import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/models/estimation_result.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/models/target_country_list.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/transport_methods/model/transport_method_model.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class PriceEstimationState extends Equatable {
  PriceEstimationState([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class InitializingPriceEstimation extends PriceEstimationState {}

class FetchingPrice extends PriceEstimationState {}

class FetchedPrice extends PriceEstimationState {
  final EstimationResult result;
  FetchedPrice({required this.result});
}

class ErrorFetchingPrice extends PriceEstimationState {
  final String error;
  ErrorFetchingPrice({required this.error});
}

class FetchingTargetCountry extends PriceEstimationState {}

class FetchedTargetCountry extends PriceEstimationState {
  final List<TargetCountryModel> result;
  FetchedTargetCountry({required this.result});
}

class ErrorFetchingTargetCountry extends PriceEstimationState {
  final String error;
  ErrorFetchingTargetCountry({required this.error});
}

class FetchingTargetCountryById extends PriceEstimationState {}

class FetchedTargetCountryById extends PriceEstimationState {
  final TargetCountryModel targetCountryModel;
  FetchedTargetCountryById({required this.targetCountryModel});
}

class ErrorFetchingTargetCountryById extends PriceEstimationState {
  final String error;
  ErrorFetchingTargetCountryById({required this.error});
}
