import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/cart/model/cart_store_model.dart';
import 'package:fardinexpress/features/product/model/product_res_model.dart';
import 'package:flutter/material.dart';

class CheckoutItem extends StatelessWidget {
  final CartStoreItem cartStoreItem;
  final ProductModelRes productModel;
  const CheckoutItem(
      {Key? key, required this.cartStoreItem, required this.productModel})
      : super(key: key);

  @override

/*************  ✨ Codeium Command ⭐  *************/
  /// Build a list tile with a product's name, price, quantity and image.
  /// The quantity is displayed in the leading widget and the image is displayed
  /// in the trailing widget. The name and price are displayed as the title and
  /// subtitle respectively.
  ///
/******  a99d8b21-c39d-4ad7-b80e-1c4567cb2484  *******/ Widget build(
      BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(5.0)),
        child: Text(cartStoreItem.quantity.toString()),
      ),
      title: Text(
        productModel.name!.toString(),
      ),
      subtitle: Container(
        child: Text("${productModel.price} \$"),
      ),
      trailing: Container(
        // color: Colors.blue,
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: ExtendedImage.network(
              productModel.image![0].toString().contains('http')
                  ? productModel.image![0].toString()
                  : 'https:${productModel.image![0].toString()}',
              // errorWidget: Image.asset("assets/img/fardin-logo.png"),
              cacheWidth: 200,
              cacheHeight: 200,
              // enableMemoryCache: true,
              clearMemoryCacheWhenDispose: true,
              clearMemoryCacheIfFailed: false,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
