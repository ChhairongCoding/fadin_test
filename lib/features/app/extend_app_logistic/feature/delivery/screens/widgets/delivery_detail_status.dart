import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/models/delivery.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/constants/app_constant.dart';
import 'package:flutter/material.dart';

class DeliveryDetailStatus extends StatelessWidget {
  final Delivery delivery;
  DeliveryDetailStatus({required this.delivery});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(standardBorderRadius)),
        padding: EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 15),
        width: double.infinity,
        child: IntrinsicHeight(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image(
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                image: AssetImage(delivery.deliveryFrom.toLowerCase() == "china"
                    ? "assets/lang/china_round_icon_256.png"
                    : "assets/lang/cambodia-flag.png"),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Container(
                height: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        delivery.code,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium!
                            .copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      // SizedBox(height: 5),
                      Expanded(
                        child: FittedBox(
                          child: Row(children: [
                            FittedBox(
                              child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.all(8),
                                      backgroundColor:
                                          delivery.status == "pending"
                                              ? Colors.orange[700]
                                              : Colors.green),
                                  child: Text(
                                    // delivery.status,
                                    delivery.status == "pending"
                                        ? "pending"
                                        : "completed",
                                    textScaleFactor: 0.9,
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            SizedBox(width: 5),
                            TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    padding: EdgeInsets.all(8),
                                    backgroundColor:
                                        Theme.of(context).primaryColor),
                                child: Text(
                                  "${delivery.total}",
                                  textScaleFactor: 0.9,
                                  style: TextStyle(color: Colors.white),
                                )),
                          ]),
                        ),
                      )
                    ]),
              ),
            ),
          ],
        )));
  }
}
//  Image(
//                 height: double.infinity,
//                 fit: BoxFit.fitHeight,
//                 image: AssetImage("assets/icons/countries/china.png"),
//               ),
