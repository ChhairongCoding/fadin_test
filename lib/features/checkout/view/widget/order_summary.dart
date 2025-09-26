import 'package:fardinexpress/features/cart/model/cart_store_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSummary extends StatelessWidget {
  final List<CartStoreItem> cartStoreModel;
  final String total;
  const OrderSummary(
      {Key? key, required this.cartStoreModel, required this.total})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            // color: Theme.of(context).buttonColor,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "cartSummary".tr,
              textScaleFactor: 1.1,
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "subTotal".tr,
                  textScaleFactor: 1.1,
                ),
                Text("\$ ${this.total.toString()}",
                    // cartStoreModel.total!,
                    // "0.00",
                    textScaleFactor: 1.1,
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // AppLocalizations.of(context)!.translate("deliveryFee")!,
                  "deliveryFee".tr,
                  textScaleFactor: 1.1,
                ),
                Text(
                    // "${cartByStoreIdModel.deliveryFee.toString()}",
                    // cartStoreModel.deliveryFee,
                    "\$ 0.00",
                    textScaleFactor: 1.1,
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // AppLocalizations.of(context)!.translate("discount")!,
                  "discount".tr,
                  textScaleFactor: 1.1,
                ),
                Text(
                    // "\$ ${cartByStoreIdModel.cartByStoreIdCoupon.toString()}",
                    "\$ 0.00",
                    textScaleFactor: 1.1,
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // AppLocalizations.of(context)!.translate("grandTotal")!,
                  "grandTotal".tr,
                  textScaleFactor: 1.1,
                ),
                Text("\$ ${this.total.toString()}",
                    // cartStoreModel.grandTotal!,
                    // "0.00",
                    textScaleFactor: 1.1,
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ],
        ));
  }
}
