import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:fardinexpress/features/cart/controller/cart_store_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget cartButton({required BuildContext context, required int index}) {
  CartStoreController _cartStoreController = Get.find<CartStoreController>();

  return badges.Badge(
      badgeStyle: BadgeStyle(
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
          badgeColor: Theme.of(context).primaryColor,
          elevation: 0),
      badgeContent: Obx(() {
        return Text(
          // "0",
          _cartStoreController.cartQty.value.toString(),
          // textScaleFactor: 0.6,
          style: TextStyle(color: Colors.white),
        );
        // if (_cartStoreController.isLoading.value) {
        //   return Text("");
        // }
        // if (_cartStoreController.cartStoreList!.taobao.isEmpty) {
        //   return Text(
        //     "0",
        //     style: TextStyle(color: Colors.white),
        //   );
        // } else {
        //   return Text(
        //     // "0",
        //     _cartStoreController.cartStoreList!.taobao.length.toString(),
        //     // textScaleFactor: 0.6,
        //     style: TextStyle(color: Colors.white),
        //   );
        // }
      }),
      // position: BadgePosition.topEnd(top: 10, end: 10),
      position: BadgePosition.topEnd(top: -8, end: -5),
      child: Image.asset(
        index == 2
            ? 'assets/icon/shopping-cart-filled.png'
            : 'assets/icon/shopping-cart-outlined.png',
        height: 25,
      )
      // Icon(index == 2 ? Icons.shopping_cart : Icons.shopping_cart_outlined),
      );
}
