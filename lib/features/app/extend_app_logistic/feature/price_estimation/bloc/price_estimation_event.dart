import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/models/estimation.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class PriceEstimationEvent extends Equatable {
  PriceEstimationEvent([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class FetchPrice extends PriceEstimationEvent {
  final Estimation estimation;
  FetchPrice({required this.estimation});
}

class FetchTargetCountryList extends PriceEstimationEvent {}

class FetchTargetCountryById extends PriceEstimationEvent {
  final String id;
  FetchTargetCountryById({required this.id});
}
