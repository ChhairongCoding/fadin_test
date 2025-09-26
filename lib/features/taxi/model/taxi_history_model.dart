class TaxiHistoryModel {
  final String? id;
  final String? total;
  final String? date;
  final String senderAddress;
  final String senderPhone;
  final String receiverAddress;
  final String receiverPhone;
  final String packagePrice;
  final String note;
  final String paymentNote;
  final String status;
  final String deliveryImage;
  final String driverId;
  final String driverName;
  final String driverPhone;
  final String receiveLat;
  final String receiveLong;
  final String pickupLat;
  final String pickupLong;
  final String grandTotal;
  final String currencySymbol;
  final String duration;
  final String distance;
  final String customerRating;
  final String customerFeedback;
  final String transportType;

  factory TaxiHistoryModel.fromJson(Map<String, dynamic> json) {
    return TaxiHistoryModel(
      id: json["id"].toString(),
      total: json["total"].toString(),
      date: json["date"].toString(),
      senderAddress: json["pickup_location"].toString(),
      senderPhone: json["pickup_phone"].toString(),
      receiverAddress: json["receiver_location"].toString(),
      receiverPhone: json["receiver_phone"].toString(),
      packagePrice: json["total"].toString(),
      note: json["note"].toString(),
      paymentNote: json["payment_note"].toString(),
      status: json["status"].toString(),
      deliveryImage: json["image_url"].toString(),
      driverId: json["delivery_driver"] == null
          ? ""
          : json["delivery_driver"]["id"].toString(),
      driverName: json["delivery_driver"] == null
          ? ""
          : json["delivery_driver"]["name"].toString(),
      driverPhone: json["delivery_driver"] == null
          ? ""
          : json["delivery_driver"]["phone"].toString(),
      receiveLat: json["delivery_driver"] == null
          ? ""
          : json["receiver_lat"].toString(),
      receiveLong: json["delivery_driver"] == null
          ? ""
          : json["receiver_long"].toString(),
      pickupLat:
          json["delivery_driver"] == null ? "" : json["pickup_lat"].toString(),
      pickupLong:
          json["delivery_driver"] == null ? "" : json["pickup_long"].toString(),
      grandTotal: json["grand_total"].toString(),
      currencySymbol: json["currency_symbol"].toString(),
      duration: json["duration"].toString(),
      distance: json["distance"].toString(),
      customerRating: json["customer_rating"].toString(),
      customerFeedback: json["customer_rating_feedback"].toString(),
      transportType:
          json["transport"] == null ? "" : json["transport"]["name"].toString(),
    );
  }
  TaxiHistoryModel(
      {required this.id,
      required this.total,
      required this.date,
      required this.senderAddress,
      required this.senderPhone,
      required this.receiverAddress,
      required this.receiverPhone,
      required this.packagePrice,
      required this.note,
      required this.paymentNote,
      required this.status,
      required this.deliveryImage,
      required this.driverId,
      required this.driverName,
      required this.driverPhone,
      required this.receiveLat,
      required this.receiveLong,
      required this.pickupLat,
      required this.pickupLong,
      required this.grandTotal,
      required this.currencySymbol,
      required this.duration,
      required this.distance,
      required this.customerRating,
      required this.customerFeedback,
      required this.transportType});
}
