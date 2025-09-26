import 'package:fardinexpress/features/app/extend_app_logistic/utils/constants/app_constant.dart';
import 'package:flutter/material.dart';

class DeliveryAddress extends StatelessWidget {
  final String address;
  DeliveryAddress({required this.address});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(standardBorderRadius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "deliveryTo",
            style: Theme.of(context).primaryTextTheme.titleMedium!.copyWith(),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "$address",
            style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(),
          ),
        ],
      ),
    );
  }
}
