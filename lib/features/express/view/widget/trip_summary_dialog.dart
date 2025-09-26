import 'package:fardinexpress/features/express/controller/express_controller.dart';
import 'package:fardinexpress/features/express/model/delivery_history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TripSummaryDialog {
  static void show(BuildContext context, DeliveryHistoryModel deliveryHistory) {
    TextEditingController customerFeedback = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Trip Summary',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child:
                        Icon(Icons.person, size: 40, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ID${deliveryHistory.driverId}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      '${deliveryHistory.transportType} - ${deliveryHistory.driverPhone}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  _buildTripAddressDetail(
                      '${'tranId'.tr}: ', 'No.${deliveryHistory.id}'),
                  _buildTripAddressDetail(
                      '${'pickUp'.tr}: ', '${deliveryHistory.senderAddress}'),
                  _buildTripAddressDetail('${'dropOff'.tr}: ',
                      '${deliveryHistory.receiverAddress == "null" ? "" : deliveryHistory.receiverAddress}'),
                  _buildTripDetail('${'totalAmountPaid'.tr}:',
                      '${deliveryHistory.grandTotal} ${deliveryHistory.currency}',
                      isBold: true),
                  // _buildTripDetail('Payment Method:', 'Cash'),
                  _buildTripDetail('${'date'.tr}:', '${deliveryHistory.date}'),
                  _buildTripDetail(
                      '${'status'.tr}:', '${deliveryHistory.status}',
                      isBold: true, color: Colors.green),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => Icon(Icons.star_border,
                          size: 32, color: Colors.green),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: customerFeedback,
                    decoration: InputDecoration(
                      hintText: 'feedBack'.tr,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                    ),
                    onPressed: () {
                      if (customerFeedback.text.isEmpty) {
                        Alert(
                          type: AlertType.info,
                          context: context,
                          style: AlertStyle(
                            titleStyle: TextStyle(fontSize: 18),
                            descTextAlign: TextAlign.start,
                            descStyle: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          title: "សូមបញ្ចូលមតិរបស់អ្នក!".tr,
                          // desc: "សូមបញ្ចូលមតិរបស់អ្នក!",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "OK".tr,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Color.fromRGBO(0, 179, 134, 1.0),
                              radius: BorderRadius.circular(8.0),
                            ),
                          ],
                        ).show();
                      } else {
                        Navigator.pop(context);
                        Get.find<ExpressController>(tag: "taxi")
                            .toSubmitCustomerRating(
                                starRate: 3,
                                customerFeedback: customerFeedback.text,
                                id: deliveryHistory.id!);
                      }
                    },
                    child: Text('rateMyRide'.tr,
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildTripDetail(String label, String value,
      {bool isBold = false, Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600])),
          Flexible(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 14,
                // fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildTripAddressDetail(String label, String value,
      {bool isBold = false, Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold)),
          Flexible(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
