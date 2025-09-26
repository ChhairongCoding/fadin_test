import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/models/estimation.dart';

class EstimationResult extends Estimation {
  final String price;
  final String condition;
  final String actualWeight;
  final String dimensionalWeight;
  final String volumeWeight;
  final String priceCondition;
  factory EstimationResult.fromJson(Map<String, dynamic> json) {
    return EstimationResult(
      price: json["price"].toString(),
      country: json["country"],
      length: json["length"].toString(),
      width: json["width"].toString(),
      height: json["height"].toString(),
      weight: json["weight"].toString(),
      priceCondition: json["price_condition"],
      volumeWeight: json["volume_weight"],
      deliveryMode: json["delivery_mode"],
      actualWeight: json["actual_weight"].toString(),
      dimensionalWeight: json["dimensional_weight"].toString(),
      condition: json["condition"],
    );
  }
  EstimationResult(
      {required this.price,
      required this.actualWeight,
      required this.condition,
      required this.dimensionalWeight,
      required this.volumeWeight,
      required this.priceCondition,
      required String weight,
      required String width,
      required String height,
      required String length,
      required String deliveryMode,
      required String country})
      : super(
            country: country,
            width: width,
            length: length,
            mode: deliveryMode,
            weight: weight,
            height: height);
}
