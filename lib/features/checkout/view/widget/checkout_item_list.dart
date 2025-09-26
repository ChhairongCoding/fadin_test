import 'package:fardinexpress/features/cart/model/cart_store_model.dart';
import 'package:fardinexpress/features/product/model/product_res_model.dart';
import 'package:flutter/material.dart';
import 'checkout_item.dart';

class CheckoutItemList extends StatelessWidget {
  final List<CartStoreItem> cartStoreModel;
  final List<ProductModelRes> productList;
  CheckoutItemList(
      {Key? key, required this.cartStoreModel, required this.productList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return CheckoutItem(
            cartStoreItem: cartStoreModel[index],
            productModel: productList[index],
          );
        });
  }
}
